import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invests_helper/base/bloc_event_base.dart';
import 'package:invests_helper/base/bloc_state_base.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_bloc.dart';
import 'package:invests_helper/data/models/response/binance/symbol_data_response.dart';
import 'package:invests_helper/data/models/response/google_sheets/google_sheet_order.dart';
import 'package:invests_helper/data/services/binance/binance_data_service_base.dart';
import 'package:invests_helper/data/services/google_sheet/google_sheet_service_base.dart';
import 'package:invests_helper/parts/orders/orders_event.dart';
import 'package:invests_helper/parts/orders/orders_state.dart';
import 'package:invests_helper/utils/time_service.dart';

class OrdersBloc extends InvestHelperBloc<OrdersEvent, GlobalState<OrdersState>,
    OrdersState> {
  final BaseGoogleSheetDataService googleSheetRepository;
  final BaseBinanceDataService binanceRepository;

  List<GoogleSheetOrder> allOrders = [];
  Map<String, SymbolData> symbolsMap = {};

  List<GoogleSheetOrder> selectedOrders = [];

  OrdersBloc({
    required this.googleSheetRepository,
    required this.binanceRepository,
  }) : super(LoadingStateBase()) {
    on<OrdersInitialEvent>(_onInitialEvent);
    on<RefreshOrdersEvent>(_onRefreshOrdersEvent);
    on<OrdersPageOrderSelected>(_onOrdersPageOrderSelected);
    on<OrdersPageMeanOrderEvent>(_onOrdersPageMeanOrderEvent);
  }

  Future<void> _onOrdersPageMeanOrderEvent(
      OrdersPageMeanOrderEvent event, Emitter<GlobalState<OrdersState>> emit) async {

    final selectedOrdersStates = event.selectedOrders;
    final selectedOrders = <GoogleSheetOrder>[];
    final allOrders = state.getContent()!.orders;

    assert(allOrders.length == selectedOrdersStates.length);

    for(var i = 0; i<selectedOrdersStates.length; i++) {
        if (selectedOrdersStates[i]) {
          selectedOrders.add(allOrders[i]);
        }
    }

    String? ordersAsset;
    int? profitPercent;
    int? sellPercent;
    for(var o in selectedOrders) {
      if (o.orderSellData.isEmpty) {
        handleHttpException('У усреднямых ордеров должны быть продажи',
            emit, state.getContent()!);
        return;
      }
      ordersAsset ??= o.pair;

      profitPercent ??= o.orderSellData[0].minIncomePercent;
      sellPercent ??= o.orderSellData[0].minPiceSellPercent;

      if (ordersAsset != o.pair) {
        handleHttpException('Усредняемые ордера должны быть одной валютной пары',
            emit, state.getContent()!);
        return;
      }

      if ((profitPercent != o.orderSellData[0].minIncomePercent) ||
          (sellPercent != o.orderSellData[0].minPiceSellPercent)) {
        handleHttpException('У усреднямых ордеров должны быть одинаковые продажи',
            emit, state.getContent()!);
        return;
      }

    }

    var buyedValue = 0.0;

    var buyedValueUsdt = 0.0;

    for(var o in selectedOrders) {
      buyedValue += o.buyedValue;
      buyedValueUsdt += o.buyedValue * o.buyedCource;
    }
    final newBuyedCurse = buyedValueUsdt / buyedValue;

    final googleSheetModel = GoogleSheetOrder(
      orderNumber: -1,
      buyedCource: newBuyedCurse,
      orderState: 'активен',
      comment: 'создан из МП',
      dateTime: IHTimeService.getNowFormatted(),
      whereCrypto: selectedOrders[0].whereCrypto,
      pair: selectedOrders[0].pair,
      buyedValue: buyedValue,
      usdEq: buyedValueUsdt,
      comission: '',
      orderSellData: selectedOrders[0].orderSellData.map((e) {
        final newPlanedCurse = newBuyedCurse * (1.0 + e.minIncomePercent/100.0);
        final newPlanedSell = buyedValue * (e.minPiceSellPercent/100.0);
        final newData = OrderSellData(
            minIncomePercent: e.minIncomePercent,
            minPiceSellPercent: e.minPiceSellPercent,
            planedSellCource: newPlanedCurse,
            planedSellValue: newPlanedSell,
            totalPredicted: newPlanedSell * newPlanedCurse,
            totalFact: 0.0
        );
        return newData;
      }).toList(),
    );
    final meanedOrdersNumbers = selectedOrders.map((e) => e.orderNumber).toList();

    try {
      await googleSheetRepository.createMeanedOrder(
          order: googleSheetModel,
          meanedOrders: meanedOrdersNumbers
      );
      add(RefreshOrdersEvent());
    } catch(e) {
      handleHttpException(e, emit, state.getContent()!);
    }

  }

  Future<void> _onOrdersPageOrderSelected(
      OrdersPageOrderSelected event, Emitter<GlobalState<OrdersState>> emit) async {

  }

  Future<void> _onRefreshOrdersEvent(
      RefreshOrdersEvent event, Emitter<GlobalState<OrdersState>> emit) async {
    try {
      await _onRefreshData(emit);
    } catch (e) {
      handleHttpException(e, emit, state.getContent()!);
    }
  }

  Future<void> _onInitialEvent(
      OrdersInitialEvent event, Emitter<GlobalState<OrdersState>> emit) async {
    emit(OrdersState.empty().toContent());

    try {
      await _onRefreshData(emit, withFetch: false);
    } catch (e) {
      handleHttpException(e, emit, OrdersState.empty());
    }
  }

  Future<void> _onRefreshData(Emitter<GlobalState<OrdersState>> emit, {
    bool withFetch = true}) async {
    // Все ордера берётся из таблиц
    allOrders = await googleSheetRepository.getOrders(isRefresh: withFetch);
    // Цены берутся из бинанса
    final currentPrices = await binanceRepository.getSymbolTickerData(
        isRefresh: withFetch);
    // Преобразовать котировки в мапу для быстрого поиска
    for (var i in currentPrices) {
      symbolsMap[i.symbol.toLowerCase()] = i;
    }

    final filteredOrders = _filterByActive();
    final prices = _buildOrderPrices(orders: filteredOrders);
    final sellData = _buildSellPiecesInfo(orders: filteredOrders, prices: prices);

    final aggregationOrderData = _aggregateOrderData(
      orders: filteredOrders,
      prices: prices,
      sellData: sellData,
    );

    _sortOrdersByPercents(aggregationData: aggregationOrderData);

    List<GoogleSheetOrder> resultOrders = [];
    List<String> resultPrices = [];
    List<List<SellPieceInfo>> resultPercents = [];

    for(var i in aggregationOrderData) {
      resultOrders.add(i.order);
      resultPrices.add(i.price);
      resultPercents.add(i.sellData);
    }


    emit(state
        .getContent()!
        .copyWith(
          orders: resultOrders,
          currentPrices: resultPrices,
          sellData: resultPercents,
        )
        .toContent());
  }

  /// Собрать в кучу все данные связанные с ордером и отображением в UI
  List<_OrderAggregation> _aggregateOrderData({
    required List<GoogleSheetOrder> orders,
    required List<String> prices,
    required List<List<SellPieceInfo>> sellData,
  }) {
    assert(orders.length == prices.length);
    assert(orders.length == sellData.length);

    final result = <_OrderAggregation>[];

    for(var i=0; i<orders.length; i++) {
      result.add(_OrderAggregation(
        sellData: sellData[i],
        price: prices[i],
        order: orders[i],
      ));
    }

    return result;

  }

  /// Отсортировать ордера по проценту
  void _sortOrdersByPercents({
    required List<_OrderAggregation> aggregationData,
  }) {

    final tempMap = <int, double>{};

    for (var i = 0; i < aggregationData.length; i++) {
      final currentPercents = aggregationData[i].sellData;
      final currentOrder = aggregationData[i].order;

      assert(currentPercents.length == currentOrder.orderSellData.length);

      double minPercent = double.infinity;

      for (var j = 0; j < currentPercents.length; j++) {
        final isSelled = currentOrder.orderSellData[j].hasSellCourse != null;
        if (isSelled) continue;
        //final curPercent = double.parse(currentPercents[j].deltaPercent);
        final curPercent = currentPercents[j].deltaPercent;
        if (curPercent < minPercent) {
          minPercent = curPercent;
        }
      }
      assert(tempMap[currentOrder.orderNumber] == null);
      tempMap[currentOrder.orderNumber] = minPercent;
    }

    aggregationData.sort((a, b) {
      return tempMap[a.order.orderNumber]!.compareTo(tempMap[b.order.orderNumber]!);
    });
  }

  List<List<SellPieceInfo>> _buildSellPiecesInfo({
    required List<GoogleSheetOrder> orders,
    required List<String> prices,
  }) {
    final List<List<SellPieceInfo>> result = [];

    for (var i = 0; i < orders.length; i++) {
      final currentOrder = orders[i];

      final currentPrice = double.parse(prices[i]);
      final buyedPrice = currentOrder.buyedCource;
      final buyedUsdValue = currentOrder.usdEq;

      final tempList = <SellPieceInfo>[];
      final sellPieces = currentOrder.orderSellData;

      for (var sp in sellPieces) {

        final sellPercent = sp.minPiceSellPercent;
        final profitPlanedPercent = sp.minIncomePercent;

        final plannedUsdValue = (1.0 + profitPlanedPercent/100.0) * buyedUsdValue * (sellPercent/100.0);


        final currentProfitUsd = (currentPrice)/buyedPrice * buyedUsdValue * (sellPercent/100.0);
        final plannedProfitUsd = plannedUsdValue;
        final currentPercent = (currentPrice - buyedPrice)/buyedPrice * 100.0;
        final plannedPercent = sp.minIncomePercent;
        final deltaPercent = plannedPercent - currentPercent;
        final newSellData = SellPieceInfo(
          currentProfitUsd: currentProfitUsd,
          plannedProfitUsd: plannedProfitUsd,
          currentPercent: currentPercent,
          deltaPercent: deltaPercent,
          plannedPercent: sp.minIncomePercent.toDouble(),
          deltaSellValue: currentProfitUsd - plannedProfitUsd,
          pieceUsdValue: buyedUsdValue * (sellPercent/100.0),
        );

        tempList.add(newSellData);
      }
      result.add(tempList);
    }

    return result;
  }

  /// Сопоставить значения процентов для ордеров
  /*List<List<String>> _buildSellPercents({
    required List<GoogleSheetOrder> orders,
    required List<String> prices,
  }) {
    final List<List<String>> result = [];

    for (var i = 0; i < orders.length; i++) {
      final o = orders[i];
      final p = double.parse(prices[i]);

      final tempList = <String>[];
      final sellPieces = o.orderSellData;
      final sellPiecesCount = sellPieces.length;

      for (var sp in sellPieces) {
        final courseDouble = sp.planedSellCource;

        //final percentValue = 1.0 - p / courseDouble;
        final percentValue = (courseDouble - p) / p;

        tempList.add((percentValue * 100.0).toStringAsFixed(2));
      }
      result.add(tempList);
    }

    return result;
  }*/

  /// Сопоставить цену с каждым из ордеров
  List<String> _buildOrderPrices({required List<GoogleSheetOrder> orders}) {
    final List<String> result = [];
    for (var i in orders) {
      final symbol = symbolsMap[i.pair];
      //assert(symbol != null, 'В теории должны быть все ключи');
      if (symbol == null) {
        // Бинанс не знает про все валюты...
        result.add('0.0');
        continue;
      }
      result.add(symbol.price);
    }
    return result;
  }

  /// Отфильтровать все ордера по активности
  List<GoogleSheetOrder> _filterByActive() {
    return allOrders.where((element) {
      switch (element.orderState.toOrderStateType()) {
        case OrderStateType.active:
          return true;
        case OrderStateType.meaned:
          return false;
        case OrderStateType.halfDone:
          return true;
        case OrderStateType.done:
          return true;
        case OrderStateType.unknown:
          return false;
      }
    }).toList();
  }

  @override
  Future<void> onInitialEvent(BaseInitialEvent event, Emitter<GlobalState<OrdersState>> emit) {
    // TODO: implement onInitialEvent
    throw UnimplementedError();
  }

  @override
  Future<void> onRefreshEvent(BaseRefreshEvent event, Emitter<GlobalState<OrdersState>> emit) {
    // TODO: implement onRefreshEvent
    throw UnimplementedError();
  }

}

/// Служебный класс для сортировки
class _OrderAggregation {
  GoogleSheetOrder order;
  String price;
  List<SellPieceInfo> sellData;

  _OrderAggregation(
      {required this.sellData, required this.price, required this.order});
}
