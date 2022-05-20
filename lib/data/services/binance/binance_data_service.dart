



import 'package:invests_helper/data/models/response/binance/get_user_data_response.dart';
import 'package:invests_helper/data/models/response/binance/symbol_data_response.dart';
import 'package:invests_helper/data/repositories/binance/base_binance_repository.dart';
import 'package:invests_helper/data/services/binance/binance_data_service_base.dart';


class BinanceDataService implements BaseBinanceDataService {

  final BaseBinanceRepository binanceRepository;
  BinanceDataService({required this.binanceRepository});

  BinanceUserDataResponse? getAccountInformationCache;
  List<SymbolData>? getSymbolTickerDataCache;

  @override
  BaseBinanceRepository getRepository() {
    return binanceRepository;
  }

  @override
  Future<BinanceUserDataResponse> getAccountInformation({bool isRefresh = false}) async {
    if (isRefresh || getAccountInformationCache == null) {
      final data = await binanceRepository.getAccountInformation();
      getAccountInformationCache = data;
      return data;
    }
    return getAccountInformationCache!;

  }

  @override
  Future<List<SymbolData>> getSymbolTickerData({bool isRefresh = false}) async {
    if (isRefresh || getSymbolTickerDataCache == null) {
      final data = await binanceRepository.getSymbolTickerData();
      getSymbolTickerDataCache = data;
      return data;
    }
    return getSymbolTickerDataCache!;
  }


}