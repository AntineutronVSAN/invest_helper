

import 'package:invests_helper/data/app_data_service.dart';
import 'package:invests_helper/data/models/response/google_sheets/all_lists_data.dart';
import 'package:invests_helper/data/models/response/google_sheets/buys_cash.dart';
import 'package:invests_helper/data/models/response/google_sheets/buys_cash_status.dart';
import 'package:invests_helper/data/models/response/google_sheets/google_sheet_order.dart';
import 'package:invests_helper/data/repositories/google_sheet/base_google_sheet_repo.dart';

/// Базовый сервис данных гугл таблиц
/// Все сервисы данных являются обёрткой над репозиториями, для того, что бы
/// была возможность делегировать запросы данных кешу, сторажам и т.п.
abstract class BaseGoogleSheetDataService implements AppDataService {

  BaseGoogleSheetRepository getRepository();

  Future<int> getOrdersCount({bool isRefresh=false});
  Future<List<GoogleSheetOrder>> getOrders({bool isRefresh=false});

  /// Создать новый ордер
  Future<void> createNewOrder({required GoogleSheetOrder order});

  /// Усреднить ордера [meanedOrders] в новый ордер [order]
  Future<void> createMeanedOrder({
    required GoogleSheetOrder order,
    required List<int> meanedOrders,
  });

  /// Получить список статусов покупки фиатной валюты
  Future<List<BuysCashStatus>> getBuysCashStatuses({required bool isRefresh});
  /// Получить список покупок фиатной валюты
  Future<List<BuysCash>> getBuysCash({required bool isRefresh});

  /// Создать новую покупку фиатной валюты
  Future<void> createNewFiatBuy({required BuysCash buy});

  /// Получить все категориальные данные
  Future<AllListsGoogleSheetData> getAllCategoryListData({required bool isRefresh});
}