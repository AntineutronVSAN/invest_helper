import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:invests_helper/const.dart';
import 'package:invests_helper/data/models/response/binance/get_user_data_response.dart';
import 'package:invests_helper/data/models/response/binance/symbol_data_response.dart';
import 'package:invests_helper/data/repositories/binance/base_binance_repository.dart';
import 'package:invests_helper/data/repositories/repository_base.dart';
import 'package:invests_helper/secure_data.dart';
import 'package:invests_helper/services/web_socket/binance_web_socket.dart';

class BinanceRepository extends BaseBackendClient
    implements BaseBinanceRepository {
  /* ------------------------ {{My data}}} --------------------------------- */
  /* ----------------------------------------------------------------------- */

  /* ------------------------ Общие данные --------------------------------- */
  // TODO Нужно сделать подключение биржи через мобилку
  static const String binanceApiKey = IHSecureData.binanceApiKey;
  static const String binanceSecretKey = IHSecureData.binanceSecretKey;

  static const CryptoMarketType marketType = CryptoMarketType.binance;
  /* ----------------------------------------------------------------------- */

  /* ------------------------ Rest API данные ------------------------------ */
  static const String binanceApiKeyHeader = 'X-MBX-APIKEY';
  static const String signatureBinanceKey = 'signature';

  static const BinanceMethod getAccountInformationPath = BinanceMethod(
      path: '/api/v3/account', needSha: true, private: true);
  static const BinanceMethod getSymbolTickerDataPath = BinanceMethod(
      path: '/api/v3/ticker/price', needSha: false, private: false);

  /* ----------------------------------------------------------------------- */

  /* ------------------------ Веб сокет --------------------------------- */
  final BinanceWebSocketService binanceWebSocketService = BinanceWebSocketService();
  /* ----------------------------------------------------------------------- */




  BinanceRepository() : super();

  /// Получить инфу о аккаунте
  @override
  Future<BinanceUserDataResponse> getAccountInformation() async {
    final dateTimeMls = DateTime.now().millisecondsSinceEpoch;
    final payLoad = <String, dynamic>{
      'timestamp': dateTimeMls.toString(),
    };
    _signPayLoad(payLoad);
    final result = await makeGetResponse(
      getAccountInformationPath.path,
      type: marketType,
      additionalParams: _getApiKeyParams(),
      queryParam: payLoad,
    );
    final userDataBinance = BinanceUserDataResponse.fromJson(result);
    return userDataBinance;
  }

  /// Получить параметры авторизации - ключ api
  Map<String, String> _getApiKeyParams() {
    return {binanceApiKeyHeader: binanceApiKey};
  }

  /// Подписать полезную нагрузку ключём [AppConst.binanceSecretKey]
  /// и добавить поле в данные. Согласно докуменации API бибнаса
  /// подписывать нужно строку параметров, типа этой:
  /// timestamp=123123123123&value=2323
  void _signPayLoad(Map<String, dynamic> payload) {
    final payLoadStr = _getQueryFromPayload(payload);
    final payLoadBytes = utf8.encode(payLoadStr);
    final hmacSha256 = Hmac(sha256, utf8.encode(binanceSecretKey));
    final signature = hmacSha256.convert(payLoadBytes);
    final signatureStr = signature.toString();

    payload[signatureBinanceKey] = signatureStr;
  }

  /// Для подписи запроса нужно получить query параметры из
  /// полезной нагрузки [payload]
  String _getQueryFromPayload(Map<String, dynamic> payload) {
    final uri = Uri.https('example.com', '/test/aa', payload);
    final queryStr = uri.query;
    return queryStr;
  }

  /// Инициализация веб сокета.
  /// Тут будет создан канал и начнётся прослушка группы стримов по
  /// символам symbols
  @override
  Future<void> initWebSocketChannel({required List<String> symbols}) async {
    await binanceWebSocketService.initWebSocket(symbols: symbols);
  }

  /// Подписаться на изменения
  @override
  void listenPricesChanged(Function(dynamic) listener) {
    binanceWebSocketService.listenPricesChanged(listener);
  }

  @override
  Future<void> closeWebSocket() async {

  }

  @override
  Future<List<SymbolData>> getSymbolTickerData() async {

    final data = await makeGetResponse(
        getSymbolTickerDataPath.path, type: CryptoMarketType.binance);
    final payload = data['result'] as List<dynamic>;
    final symbols = payload.map((e) => SymbolData.fromJson(e)).toList();

    return symbols;

  }

}

/// Методы бинанса имеют свои особенности поэтому кроме простого пути
/// есть ещё другие параметры. Класс нужен просто для струкризации
class BinanceMethod {
  final String path;
  final bool private;
  final bool needSha;

  const BinanceMethod({
    required this.path,
    required this.needSha,
    required this.private,
  });
}









