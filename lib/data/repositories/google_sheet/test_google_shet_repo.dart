
import 'package:invests_helper/data/models/response/google_sheets/all_lists_data.dart';
import 'package:invests_helper/data/models/response/google_sheets/buys_cash.dart';
import 'package:invests_helper/data/models/response/google_sheets/buys_cash_status.dart';
import 'package:invests_helper/data/models/response/google_sheets/diet.dart';
import 'package:invests_helper/data/models/response/google_sheets/google_sheet_order.dart';
import 'package:invests_helper/data/repositories/google_sheet/base_google_sheet_repo.dart';
import 'package:invests_helper/data/repositories/repository_base.dart';


class TestGoogleSheetRepository extends BaseBackendClient implements BaseGoogleSheetRepository {

  @override
  Future<int> getOrdersCount() async {
    return 30;
  }

  @override
  Future<List<GoogleSheetOrder>> getOrders() {
    // TODO: implement getOrders
    throw UnimplementedError();
  }

  @override
  Future<void> createNewOrder({required GoogleSheetOrder order}) {
    // TODO: implement createNewOrder
    throw UnimplementedError();
  }

  @override
  Future<void> createMeanedOrder({required GoogleSheetOrder order, required List<int> meanedOrders}) {
    // TODO: implement createMeanedOrder
    throw UnimplementedError();
  }

  @override
  Future<List<BuysCashStatus>> getBuysCashStatuses() {
    // TODO: implement getBuysCashStatuses
    throw UnimplementedError();
  }

  @override
  Future<List<BuysCash>> getBuysCash() {
    // TODO: implement getBuysCash
    throw UnimplementedError();
  }

  @override
  Future<void> createNewFiatBuy({required BuysCash buy}) {
    // TODO: implement createNewFiatBuy
    throw UnimplementedError();
  }

  @override
  Future<AllListsGoogleSheetData> getAllCategoryListData() {
    // TODO: implement getAllCategoryListData
    throw UnimplementedError();
  }

  @override
  Future<DietAllDataModel> getAllDietData() {
    // TODO: implement getAllDietData
    throw UnimplementedError();
  }

  @override
  Future<void> addWeightJournalEntry({required DietWeightJournalModel entry}) {
    // TODO: implement addWeightJournalEntry
    throw UnimplementedError();
  }

  @override
  Future<void> addDietJournalEntry({required DietJournalModel entry}) {
    // TODO: implement addDietJournalEntry
    throw UnimplementedError();
  }

}