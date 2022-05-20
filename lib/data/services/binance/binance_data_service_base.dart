

import 'package:invests_helper/data/models/response/binance/get_user_data_response.dart';
import 'package:invests_helper/data/models/response/binance/symbol_data_response.dart';
import 'package:invests_helper/data/repositories/binance/base_binance_repository.dart';

/// Базовый сервис данных бинанса
/// Все сервисы данных являются обёрткой над репозиториями, для того, что бы
/// была возможность делегировать запросы данных кешу, сторажам и т.п.
abstract class BaseBinanceDataService {

  BaseBinanceRepository getRepository();

  /// Инфа о аккаунте
  Future<BinanceUserDataResponse> getAccountInformation({bool isRefresh=false});
  /// Получить текущий прайс все валют
  Future<List<SymbolData>> getSymbolTickerData({bool isRefresh=false});


}