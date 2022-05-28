

import 'package:invests_helper/data/models/response/google_sheets/all_lists_data.dart';
import 'package:invests_helper/data/models/response/google_sheets/buys_cash.dart';
import 'package:invests_helper/data/models/response/google_sheets/buys_cash_status.dart';
import 'package:invests_helper/data/models/response/google_sheets/diet.dart';
import 'package:invests_helper/data/models/response/google_sheets/google_sheet_order.dart';

abstract class BaseGoogleSheetRepository {

  /// Сколько ордеров есть в документе.
  /// Метод используется как пинг-понг
  Future<int> getOrdersCount();


  Future<List<GoogleSheetOrder>> getOrders();

  Future<void> createNewOrder({required GoogleSheetOrder order});

  /// Усреднить ордера [meanedOrders] в новый ордер [order]
  Future<void> createMeanedOrder({
    required GoogleSheetOrder order,
    required List<int> meanedOrders,
  });

  /// Получить список статусов покупки фиатной валюты
  Future<List<BuysCashStatus>> getBuysCashStatuses();

  /// Получить список покупок фиатной валюты
  Future<List<BuysCash>> getBuysCash();

  /// Создать новую покупку фиатной валюты
  Future<void> createNewFiatBuy({required BuysCash buy});

  /// Получить все категориальные данные
  Future<AllListsGoogleSheetData> getAllCategoryListData();

  /// Получить все данные, связанные с диетой
  Future<DietAllDataModel> getAllDietData();

  /// Добавить в таблицу новую запись веса
  Future<void> addWeightJournalEntry({required DietWeightJournalModel entry});

}