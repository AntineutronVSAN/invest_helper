

import 'package:invests_helper/data/models/response/google_sheets/all_lists_data.dart';
import 'package:invests_helper/data/models/response/google_sheets/buys_cash.dart';
import 'package:invests_helper/data/models/response/google_sheets/buys_cash_status.dart';
import 'package:invests_helper/data/models/response/google_sheets/diet.dart';
import 'package:invests_helper/data/models/response/google_sheets/google_sheet_order.dart';
import 'package:invests_helper/data/repositories/google_sheet/base_google_sheet_repo.dart';
import 'package:invests_helper/data/services/google_sheet/google_sheet_service_base.dart';

class GoogleSheetDataService implements BaseGoogleSheetDataService {

  final BaseGoogleSheetRepository googleSheetRepository;
  GoogleSheetDataService({required this.googleSheetRepository});

  // ------------ Кеш, хранится в опертивной памяти -----------------
  List<GoogleSheetOrder>? getOrdersCache;
  int? getOrdersCountCache;
  List<BuysCashStatus>? buysCashStatusesCache;
  List<BuysCash>? buysCashCache;
  AllListsGoogleSheetData? allListsGoogleSheetDataCache;
  DietAllDataModel? dietAllDataModelCache;

  @override
  BaseGoogleSheetRepository getRepository() {
    return googleSheetRepository;
  }

  @override
  Future<List<GoogleSheetOrder>> getOrders({bool isRefresh=false}) async {
    if (isRefresh || getOrdersCache == null) {
      final data = await googleSheetRepository.getOrders();
      getOrdersCache = data;
      return data;
    }
    return getOrdersCache!;
  }

  @override
  Future<int> getOrdersCount({bool isRefresh=false}) async {
    if (isRefresh || getOrdersCountCache == null) {
      final data = await googleSheetRepository.getOrdersCount();
      getOrdersCountCache = data;
      return data;
    }
    return getOrdersCountCache!;
  }

  @override
  Future<void> createNewOrder({required GoogleSheetOrder order}) async {
    await googleSheetRepository.createNewOrder(order: order);
  }

  @override
  Future<void> createMeanedOrder({required GoogleSheetOrder order, required List<int> meanedOrders}) async {
    await googleSheetRepository.createMeanedOrder(order: order, meanedOrders: meanedOrders);
  }

  @override
  Future<List<BuysCashStatus>> getBuysCashStatuses({required bool isRefresh}) async {
    if (isRefresh || buysCashStatusesCache == null) {
      final data = await googleSheetRepository.getBuysCashStatuses();
      buysCashStatusesCache = data;
      return data;
    }
    return buysCashStatusesCache!;
  }

  @override
  Future<List<BuysCash>> getBuysCash({required bool isRefresh}) async {
    if (isRefresh || buysCashCache == null) {
      final data = await googleSheetRepository.getBuysCash();
      buysCashCache = data;
      return data;
    }
    return buysCashCache!;
  }

  @override
  Future<void> createNewFiatBuy({required BuysCash buy}) async {
    await googleSheetRepository.createNewFiatBuy(buy: buy);
  }

  @override
  Future<AllListsGoogleSheetData> getAllCategoryListData({required bool isRefresh}) async {
    if (isRefresh || allListsGoogleSheetDataCache == null) {
      final data = await googleSheetRepository.getAllCategoryListData();
      allListsGoogleSheetDataCache = data;
      return data;
    }
    return allListsGoogleSheetDataCache!;
  }

  @override
  Future<DietAllDataModel> getAllDietData({required bool isRefresh}) async {
    if (isRefresh || dietAllDataModelCache == null) {
      final data = await googleSheetRepository.getAllDietData();
      dietAllDataModelCache = data;
      return data;
    }
    return dietAllDataModelCache!;
  }

  @override
  Future<void> addWeightJournalEntry({required DietWeightJournalModel entry}) async {
    await googleSheetRepository.addWeightJournalEntry(entry: entry);
  }

  @override
  Future<void> addDietJournalEntry({required DietJournalModel entry}) async {
    await googleSheetRepository.addDietJournalEntry(entry: entry);
  }
}