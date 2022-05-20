import 'package:invests_helper/data/models/response/binance/get_user_data_response.dart';
import 'package:invests_helper/data/models/response/binance/symbol_data_response.dart';

abstract class BaseBinanceRepository {
  /// Инфа о аккаунте
  Future<BinanceUserDataResponse> getAccountInformation();

  /// Запустить прослушку стримов по символам
  Future<void> initWebSocketChannel({required List<String> symbols});

  /// Подписаться на события от вебсокета
  void listenPricesChanged(Function(dynamic) listener);

  /// Получить текущий прайс все валют
  Future<List<SymbolData>> getSymbolTickerData();

  Future<void> closeWebSocket();
}