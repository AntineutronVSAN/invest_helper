

import 'dart:convert';

import 'package:invests_helper/data/models/response/google_sheets/all_lists_data.dart';
import 'package:invests_helper/data/models/response/google_sheets/buys_cash.dart';
import 'package:invests_helper/data/models/response/google_sheets/buys_cash_status.dart';
import 'package:invests_helper/data/models/response/google_sheets/diet.dart';
import 'package:invests_helper/data/models/response/google_sheets/google_sheet_order.dart';
import 'package:invests_helper/data/repositories/google_sheet/base_google_sheet_repo.dart';
import 'package:invests_helper/data/repositories/repository_base.dart';
import 'package:invests_helper/secure_data.dart';


class GoogleSheetRepository extends BaseBackendClient implements BaseGoogleSheetRepository {

  // todo Задавать через мобилку
  static const String startScriptUrlProd = IHSecureData.startScriptUrlProd;
  static const String identifier = IHSecureData.identifier;

  static const String accessToken = IHSecureData.accessToken;
  static const String accessTokenKey = 'accessToken';

  // [GET] START
  static const String getOrdersCountCode = '0';
  static const String getOrdersCode = '1';
  static const String getBuysCashStatusesCode = '2';
  static const String getBuysCashCode = '3';
  static const String getCategoriesList = 'getAllListsDataRoute';
  static const String getDietAllData = 'allDietDataRoute';
  // [GET] END

  // [POST] START
  static const String setNewOrderCode = '0';
  static const String setNewMeanedOrderCode = '1';

  static const String createNewFiatBuyRoute = 'createBuysCashCode';
  static const String createNewWeightJournalEntryRoute = 'dietWeightJournalAddRoute';
  // [POST] END
  @override
  Future<int> getOrdersCount() async {

    final result = await makeGetResponse(
        startScriptUrlProd, type: CryptoMarketType.googleSheets,
      queryParam: {
        'type': getOrdersCountCode,
        accessTokenKey: accessToken,
      }
    );
    return result['result']['ordersCount'];
  }

  @override
  Future<List<GoogleSheetOrder>> getOrders() async {

    final result = await makeGetResponse(
        startScriptUrlProd, type: CryptoMarketType.googleSheets,
        queryParam: {
          'type': getOrdersCode,
          accessTokenKey: accessToken,
        }
    );

    final list = result['result'] as List<dynamic>;
    final orders = list.map((e) => GoogleSheetOrder.fromJson(e)).toList();
    return orders;


  }

  @override
  Future<void> createNewOrder({required GoogleSheetOrder order}) async {
    final jsonOrder = order.toJson();
    final stringOrderDeleteMePlease = jsonEncode(jsonOrder);
    final requestBody = {
      'type': setNewOrderCode,
      'data': jsonOrder,
    };

    final result = await makePostResponse(
      startScriptUrlProd, type: CryptoMarketType.googleSheets,
      body: requestBody,
      queryParameters: {
        accessTokenKey: accessToken,
      },
    );
    print(result);
  }

  @override
  Future<void> createMeanedOrder({
    required GoogleSheetOrder order,
    required List<int> meanedOrders,
  }) async {

    final requestBody = {
      'type': setNewMeanedOrderCode,
      'data': {
        'order': order.toJson(),
        'meaned': meanedOrders,
      },
    };

    final result = await makePostResponse(
      startScriptUrlProd, type: CryptoMarketType.googleSheets,
      body: requestBody,
      queryParameters: {
        accessTokenKey: accessToken,
      },
    );
    print(result);

  }

  @override
  Future<List<BuysCashStatus>> getBuysCashStatuses() async {
    final result = await makeGetResponse(
        startScriptUrlProd, type: CryptoMarketType.googleSheets,
        queryParam: {
          'type': getBuysCashStatusesCode,
          accessTokenKey: accessToken,
        }
    );

    final list = result['result'] as List<dynamic>;
    final statuses = list.map((e) => BuysCashStatus.fromJson(e)).toList();
    return statuses;
  }

  @override
  Future<List<BuysCash>> getBuysCash() async {
    final result = await makeGetResponse(
        startScriptUrlProd, type: CryptoMarketType.googleSheets,
        queryParam: {
          'type': getBuysCashCode,
          accessTokenKey: accessToken,
        }
    );

    final list = result['result'] as List<dynamic>;
    final buys = list.map((e) => BuysCash.fromJson(e)).toList();
    return buys;
  }

  @override
  Future<void> createNewFiatBuy({required BuysCash buy}) async {
    final requestBody = {
      'type': createNewFiatBuyRoute,
      'data': {
        'buy': buy.toJson(),
      },
    };

    final result = await makePostResponse(
      startScriptUrlProd, type: CryptoMarketType.googleSheets,
      body: requestBody,
      queryParameters: {
        accessTokenKey: accessToken,
      },
    );
  }

  @override
  Future<AllListsGoogleSheetData> getAllCategoryListData() async {
    final result = await makeGetResponse(
        startScriptUrlProd, type: CryptoMarketType.googleSheets,
        queryParam: {
          'type': getCategoriesList,
          accessTokenKey: accessToken,
        }
    );
    final json = result['result'] as Map<String, dynamic>;
    final data = AllListsGoogleSheetData.fromJson(json);
    return data;
  }

  @override
  Future<DietAllDataModel> getAllDietData() async {
    final result = await makeGetResponse(
        startScriptUrlProd, type: CryptoMarketType.googleSheets,
        queryParam: {
          'type': getDietAllData,
          accessTokenKey: accessToken,
        }
    );
    final json = result['result'] as Map<String, dynamic>;
    final data = DietAllDataModel.fromJson(json);
    return data;
  }

  @override
  Future<void> addWeightJournalEntry({required DietWeightJournalModel entry}) async {
    final requestBody = {
      'type': createNewWeightJournalEntryRoute,
      'data': {
        'dietWeightJournalAddDataKey': entry.toJson(),
      },
    };

    final result = await makePostResponse(
      startScriptUrlProd, type: CryptoMarketType.googleSheets,
      body: requestBody,
      queryParameters: {
        accessTokenKey: accessToken,
      },
    );
  }
}

