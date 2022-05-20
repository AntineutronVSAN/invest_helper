import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invests_helper/base/bloc_event_base.dart';
import 'package:invests_helper/base/bloc_state_base.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_bloc.dart';
import 'package:invests_helper/data/models/response/google_sheets/google_sheet_order.dart';
import 'package:invests_helper/data/services/binance/binance_data_service_base.dart';
import 'package:invests_helper/data/services/google_sheet/google_sheet_service_base.dart';
import 'package:invests_helper/parts/orders/create_order_page/create_order_event.dart';
import 'package:invests_helper/parts/orders/create_order_page/create_order_state.dart';

import 'package:invests_helper/utils/time_service.dart';

class CreateOrderBloc extends InvestHelperBloc<CreateOrderEvent,
    GlobalState<CreateOrderPageState>, CreateOrderPageState> {
  final BaseBinanceDataService binanceRepository;
  final BaseGoogleSheetDataService googleSheetDataService;

  /// Данные по площадкам, где можно создать ордер
  _MarketsData marketsData = _MarketsData();

  /// Данные по курсам в бинансе
  _BinanseAssetsData binanceAssetsData = _BinanseAssetsData();

  CreateOrderBloc({required this.binanceRepository, required this.googleSheetDataService})
      : super(LoadingStateBase()) {
    on<CreateOrderEventInitialEvent>(_onCreateOrderEventInitialEvent);
    on<WhereCreateOrderSelectedEvent>(_onWhereCreateOrderSelectedEvent);
    on<AssetSelectedEvent>(_onAssetSelectedEvent);
    on<HowBuyCryptoChangedEvent>(_onHowBuyCryptoChangedEvent);

    on<CreateOrderSellDeletedEvent>(_onCreateOrderSellDeletedEvent);
    on<CreateOrderSellAddedEvent>(_onCreateOrderSellAddedEvent);
    on<CreateOrderProfitPercentChangedEvent>(
        _onCreateOrderProfitPercentChangedEvent);
    on<CreateOrderSellPercentChangedEvent>(
        _onCreateOrderSellPercentChangedEvent);

    on<CreateOrderNewOrderConfirmEvent>(
        _onCreateOrderNewOrderConfirmEvent);
  }

  Future<void> _onCreateOrderNewOrderConfirmEvent(
      CreateOrderNewOrderConfirmEvent event,
      Emitter<GlobalState<CreateOrderPageState>> emit) async {


    emit(state.getContent()!.copyWith(createOrderLoading: true).toContent());

    try {
      await _createGoogleSheetOrder(event, emit);
    } catch(e) {
      handleHttpException(e, emit, state.getContent()!);
      emit(state.getContent()!.copyWith(createOrderLoading: false).toContent());
      return;
    }

    try {
      await _createBinanceOrder(event, emit);
    }catch(e) {
      handleHttpException(e, emit, state.getContent()!);
      emit(state.getContent()!.copyWith(createOrderLoading: false).toContent());
      return;
    }

    emit(state.getContent()!.copyWith(
      orderCreatedSuccessfully: true,
      createOrderLoading: false,
    ).toContent());


  }

  Future<void> _createGoogleSheetOrder(
      CreateOrderNewOrderConfirmEvent event,
      Emitter<GlobalState<CreateOrderPageState>> emit) async {

    final stateData = state.getContent()!;

    final buyCurse = stateData.assetsPrices[stateData.selectedAsset];
    final buyCryptoValue = stateData.howBySliderData.cryptoValue;

    final googleSheetModel = GoogleSheetOrder(
        orderNumber: -1,
        buyedCource: stateData.assetsPrices[stateData.selectedAsset],
        orderState: 'активен',
        comment: 'создан из МП',
        dateTime: IHTimeService.getNowFormatted(),
        whereCrypto: stateData.whereCreateOrder[stateData.selectedWhereCanCreateOrder],
        pair: stateData.assets[stateData.selectedAsset].toLowerCase(),
        buyedValue: buyCryptoValue,
        usdEq: stateData.howBySliderData.usdtValue,
        comission: '',
        orderSellData: stateData.sellsData.map((e) {
          return OrderSellData(
              minIncomePercent: e.profitPercent,
              minPiceSellPercent: e.sellPercent,
              planedSellCource: buyCurse * (1.0 + e.profitPercent/100.0),
              planedSellValue: buyCryptoValue * (e.sellPercent / 100.0),
              totalPredicted: 0.0,
              totalFact: 0.0
          );
        }).toList(),
    );

    await googleSheetDataService.createNewOrder(order: googleSheetModel);



  }

  Future<void> _createBinanceOrder(
      CreateOrderNewOrderConfirmEvent event,
      Emitter<GlobalState<CreateOrderPageState>> emit) async {

  }


  Future<void> _onCreateOrderSellPercentChangedEvent(
      CreateOrderSellPercentChangedEvent event,
      Emitter<GlobalState<CreateOrderPageState>> emit) async {
    final content = state.getContent()!;
    final buyValue = content.howBySliderData.currentValue;
    final index = event.index;
    final newValue = event.value;
    content.sellsData[index].sellPercent = newValue;
    content.sellsData[index].recalculateProfit(buyValue);
    emit(content
        .copyWith(
            sellsDataError: _validateSellsData(content.sellsData, buyValue))
        .toContent());
  }

  Future<void> _onCreateOrderProfitPercentChangedEvent(
      CreateOrderProfitPercentChangedEvent event,
      Emitter<GlobalState<CreateOrderPageState>> emit) async {
    final content = state.getContent()!;
    final buyValue = content.howBySliderData.currentValue;
    final index = event.index;
    final newValue = event.value;
    content.sellsData[index].profitPercent = newValue;
    content.sellsData[index].recalculateProfit(buyValue);
    emit(content
        .copyWith(
            sellsDataError: _validateSellsData(content.sellsData, buyValue))
        .toContent());
  }

  Future<void> _onCreateOrderSellAddedEvent(CreateOrderSellAddedEvent event,
      Emitter<GlobalState<CreateOrderPageState>> emit) async {
    final content = state.getContent()!;
    final buyValue = content.howBySliderData.currentValue;

    content.sellsData.add(CreateOrderSellData(
      profitPercent: 0,
      sellPercent: 0,
      usdtAsset: 'usdt',
      usdtProfit: 0.0,
    ));
    emit(content
        .copyWith(
            sellsDataError: _validateSellsData(content.sellsData, buyValue))
        .toContent());
  }

  Future<void> _onCreateOrderSellDeletedEvent(CreateOrderSellDeletedEvent event,
      Emitter<GlobalState<CreateOrderPageState>> emit) async {
    final content = state.getContent()!;
    final buyValue = content.howBySliderData.currentValue;

    content.sellsData.removeAt(event.index);
    emit(content
        .copyWith(
            sellsDataError: _validateSellsData(content.sellsData, buyValue))
        .toContent());
  }

  Future<void> _onHowBuyCryptoChangedEvent(HowBuyCryptoChangedEvent event,
      Emitter<GlobalState<CreateOrderPageState>> emit) async {
    final content = state.getContent()!;
    final usdt = event.usdt;
    content.howBySliderData.setNewCurrentValue(value: usdt);

    // При изменении слайдера нужно пересчитать профиты продаж
    for (var i in content.sellsData) {
      i.recalculateProfit(usdt);
    }

    emit(state.getContent()!.copyWith(sellsDataError: _validateSellsData(content.sellsData, usdt)).toContent());
  }

  Future<void> _onCreateOrderEventInitialEvent(
      CreateOrderEventInitialEvent event,
      Emitter<GlobalState<CreateOrderPageState>> emit) async {
    try {
      final currentAssets = await binanceRepository.getSymbolTickerData();
      final currentUserData = await binanceRepository.getAccountInformation();

      final filtered = filterNonUSDTSymbols(currentAssets);
      for (var i in filtered) {
        binanceAssetsData.assets.add(i.symbol);
        binanceAssetsData.assetPrices.add(double.parse(i.price));
      }

      // TODO Пока хардкод, т.к. на счёте мало денег
      const userBalance = 100.0;

      final sliderData = CreateOrderSliderData(
          usdtValue: userBalance,
          usdtAsset: 'usdt',
          cryptoValue: 0.0,
          cryptoAsset: binanceAssetsData.getCurrentAsset(),
          cryptoAssetPrice: binanceAssetsData.getCurrentAssetPrice(),
          minValue: 0.0,
          maxValue: userBalance,
          currentValue: 0.0);

      emit(CreateOrderPageState(
        comment: '',
        whereCreateOrder: marketsData.whereCanCreate,
        selectedWhereCanCreateOrder: marketsData.selectedCanCreateIndex,
        assets: binanceAssetsData.assets,
        selectedAsset: binanceAssetsData.selectedAsset,
        assetsPrices: binanceAssetsData.assetPrices,
        howBySliderData: sliderData,
        userBalanceUsdt: userBalance,
        sellsData: [],
      ).toContent());
    } catch (e) {
      handleHttpException(e, emit, CreateOrderPageState.empty());
    }
  }

  /// Выбрали новый ассет
  Future<void> _onAssetSelectedEvent(AssetSelectedEvent event,
      Emitter<GlobalState<CreateOrderPageState>> emit) async {
    final content = state.getContent()!;

    binanceAssetsData.selectedAsset = event.selectedIndex;

    // Пересчитать данные слайдера
    content.howBySliderData.setNewAsset(
      assetName: binanceAssetsData.getCurrentAsset(),
      assetPrice: binanceAssetsData.getCurrentAssetPrice(),
    );

    emit(content
        .copyWith(
          selectedAsset: binanceAssetsData.selectedAsset,
        )
        .toContent());
  }

  /// Выбрали, где будет совершён ордер
  Future<void> _onWhereCreateOrderSelectedEvent(
      WhereCreateOrderSelectedEvent event,
      Emitter<GlobalState<CreateOrderPageState>> emit) async {
    marketsData.selectedCanCreateIndex = event.selectedIndex;
    emit(state
        .getContent()!
        .copyWith(
          selectedWhereCanCreateOrder: marketsData.selectedCanCreateIndex,
        )
        .toContent());
  }

  String? _validateSellsData(List<CreateOrderSellData> sells, double buyValue) {
    if (sells.isEmpty) return 'Обязательное поле';
    var sumSellPercent = 0;

    for (var i in sells) {
      final solValue =
          (1.0 + i.profitPercent / 100.0) * buyValue * (i.sellPercent / 100.0);
      if (solValue < 10.0) return r'Продажа должна быть минимум 10$';
      sumSellPercent += i.sellPercent;
    }

    if (sumSellPercent != 100) return 'Сумма частей продаж должна быть 100%';

    return null;
  }

  @override
  Future<void> onInitialEvent(BaseInitialEvent event, Emitter<GlobalState<CreateOrderPageState>> emit) {
    // TODO: implement onInitialEvent
    throw UnimplementedError();
  }

  @override
  Future<void> onRefreshEvent(BaseRefreshEvent event, Emitter<GlobalState<CreateOrderPageState>> emit) {
    // TODO: implement onRefreshEvent
    throw UnimplementedError();
  }
}

class _MarketsData {
  /// todo пока захардкожено
  List<String> whereCanCreate = [
    WhereCreateOrder.binance.toString().split('.')[1],
    WhereCreateOrder.googleSheet.toString().split('.')[1],
    WhereCreateOrder.googleSheetAndBinance.toString().split('.')[1],
    WhereCreateOrder.binance.toString().split('.')[1],
    WhereCreateOrder.googleSheet.toString().split('.')[1],
    WhereCreateOrder.googleSheetAndBinance.toString().split('.')[1],
    WhereCreateOrder.binance.toString().split('.')[1],
    WhereCreateOrder.googleSheet.toString().split('.')[1],
    WhereCreateOrder.googleSheetAndBinance.toString().split('.')[1],
    WhereCreateOrder.binance.toString().split('.')[1],
    WhereCreateOrder.googleSheet.toString().split('.')[1],
    WhereCreateOrder.googleSheetAndBinance.toString().split('.')[1],
    WhereCreateOrder.binance.toString().split('.')[1],
    WhereCreateOrder.googleSheet.toString().split('.')[1],
    WhereCreateOrder.googleSheetAndBinance.toString().split('.')[1],
    WhereCreateOrder.binance.toString().split('.')[1],
    WhereCreateOrder.googleSheet.toString().split('.')[1],
    WhereCreateOrder.googleSheetAndBinance.toString().split('.')[1],
    WhereCreateOrder.binance.toString().split('.')[1],
    WhereCreateOrder.googleSheet.toString().split('.')[1],
    WhereCreateOrder.googleSheetAndBinance.toString().split('.')[1],
    WhereCreateOrder.binance.toString().split('.')[1],
    WhereCreateOrder.googleSheet.toString().split('.')[1],
    WhereCreateOrder.googleSheetAndBinance.toString().split('.')[1],
  ];
  int selectedCanCreateIndex = 0;
}

class _BinanseAssetsData {
  List<String> assets = [];

  /// Какой ассет сейчас выделен
  int selectedAsset = 0;

  /// Текущий курс ассета
  List<double> assetPrices = [];

  String getCurrentAsset() {
    if (assets.isEmpty) return '';
    return assets[selectedAsset];
  }

  double getCurrentAssetPrice() {
    if (assetPrices.isEmpty) return 0.0;
    return assetPrices[selectedAsset];
  }
}
