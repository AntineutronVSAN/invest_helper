import 'package:invests_helper/base/bloc_state_base.dart';

class CreateOrderPageState extends BaseState<CreateOrderPageState> {
  /// При создании ордерка указывается на какой бирже он создаётся
  final List<String> whereCreateOrder;
  final int selectedWhereCanCreateOrder;

  final String? hasErrors;

  final List<String> assets;
  final int selectedAsset;
  final List<double> assetsPrices;

  final String comment;
  final double userBalanceUsdt;

  final CreateOrderSliderData howBySliderData;

  final List<CreateOrderSellData> sellsData;
  final String? sellsDataError;

  final bool orderCreatedSuccessfully;
  final bool createOrderLoading;

  CreateOrderPageState({
    required this.comment,
    required this.whereCreateOrder,
    required this.selectedWhereCanCreateOrder,
    required this.assets,
    required this.selectedAsset,
    required this.assetsPrices,
    required this.howBySliderData,
    required this.userBalanceUsdt,
    required this.sellsData,
    this.sellsDataError,
    this.hasErrors,
    this.orderCreatedSuccessfully=false,
    this.createOrderLoading=false,
  });

  factory CreateOrderPageState.empty() {
    return CreateOrderPageState(
      comment: '',
      whereCreateOrder: [''],
      selectedWhereCanCreateOrder: 0,
      assets: [''],
      selectedAsset: 0,
      assetsPrices: [0.0],
      howBySliderData: CreateOrderSliderData.empty(),
      userBalanceUsdt: 0.0,
      sellsData: [],
    );
  }

  CreateOrderPageState copyWith({
    List<String>? whereCreateOrder,
    int? selectedWhereCanCreateOrder,
    String? comment,
    List<String>? assets,
    int? selectedAsset,
    List<double>? assetsPrices,
    CreateOrderSliderData? howBySliderData,
    double? userBalanceUsdt,
    List<CreateOrderSellData>? sellsData,
    String? sellsDataError,
    String? hasErrors,
    bool? orderCreatedSuccessfully,
    bool? createOrderLoading,
  }) {
    return CreateOrderPageState(
      comment: comment ?? this.comment,
      whereCreateOrder: whereCreateOrder ?? this.whereCreateOrder,
      selectedWhereCanCreateOrder:
          selectedWhereCanCreateOrder ?? this.selectedWhereCanCreateOrder,
      assets: assets ?? this.assets,
      selectedAsset: selectedAsset ?? this.selectedAsset,
      assetsPrices: assetsPrices ?? this.assetsPrices,
      howBySliderData: howBySliderData ?? this.howBySliderData,
      userBalanceUsdt: userBalanceUsdt ?? this.userBalanceUsdt,
      sellsData: sellsData ?? this.sellsData,
      sellsDataError: sellsDataError,
      hasErrors: hasErrors ?? this.hasErrors,
      orderCreatedSuccessfully: orderCreatedSuccessfully ?? this.orderCreatedSuccessfully,
      createOrderLoading: createOrderLoading ?? this.createOrderLoading,
    );
  }
}

class CreateOrderSellData {
  int profitPercent;
  int sellPercent;
  double usdtProfit;
  String usdtAsset;

  CreateOrderSellData({
    required this.profitPercent,
    required this.sellPercent,
    required this.usdtAsset,
    required this.usdtProfit,
  });

  void recalculateProfit(double value) {
    usdtProfit = value * (1.0 + profitPercent / 100.0) * sellPercent / 100.0;
  }
}

class CreateOrderSliderData {
  double usdtValue;
  String usdtAsset;

  double cryptoValue;
  String cryptoAsset;
  double cryptoAssetPrice;

  double minValue;
  double maxValue;
  double currentValue;

  CreateOrderSliderData({
    required this.usdtValue,
    required this.usdtAsset,
    required this.cryptoValue,
    required this.cryptoAsset,
    required this.cryptoAssetPrice,
    required this.minValue,
    required this.maxValue,
    required this.currentValue,
  });

  factory CreateOrderSliderData.empty() {
    return CreateOrderSliderData(
        usdtValue: 0.0,
        usdtAsset: '',
        cryptoValue: 0.0,
        cryptoAsset: '',
        cryptoAssetPrice: 0.0,
        minValue: 0.0,
        maxValue: 1.0,
        currentValue: 0.0);
  }

  void setNewCurrentValue({required double value}) {
    assert(value >= minValue && value <= maxValue);
    usdtValue = value;
    currentValue = value;
    _recalculateDataCryptoData();
  }

  void setNewAsset({
    required String assetName,
    required double assetPrice,
  }) {
    cryptoAsset = assetName;
    cryptoAssetPrice = assetPrice;
    _recalculateDataCryptoData();
  }

  void _recalculateDataCryptoData() {
    cryptoValue = currentValue / cryptoAssetPrice;
  }
}

enum WhereCreateOrder {
  binance,
  bybit,
  googleSheet,
  googleSheetAndBinance,
  unknown,
}

extension WhereCreateOrderToOrder on String {
  WhereCreateOrder toWhereCreateOrder() {
    switch (this) {
      case 'binance':
        return WhereCreateOrder.binance;
      case 'bybit':
        return WhereCreateOrder.bybit;
      case 'googleSheet':
        return WhereCreateOrder.googleSheet;
      case 'googleSheetAndBinance':
        return WhereCreateOrder.googleSheetAndBinance;
    }

    return WhereCreateOrder.unknown;
  }
}
