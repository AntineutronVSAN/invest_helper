
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invests_helper/base/bloc_event_base.dart';
import 'package:invests_helper/base/bloc_state_base.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_bloc.dart';
import 'package:invests_helper/data/models/app_models/app_crypto_balance.dart';
import 'package:invests_helper/data/models/response/binance/get_user_data_response.dart';
import 'package:invests_helper/data/models/response/binance/symbol_data_response.dart';
import 'package:invests_helper/data/models/response/binance/web_socket_models.dart';
import 'package:invests_helper/data/services/binance/binance_data_service_base.dart';
import 'package:invests_helper/data/services/google_sheet/google_sheet_service_base.dart';
import 'package:invests_helper/parts/actives/actives_event.dart';
import 'package:invests_helper/parts/actives/actives_state.dart';
import 'package:invests_helper/utils/asset_equals.dart';

class ActivesBloc extends InvestHelperBloc<ActivesEvent,
    GlobalState<ActivesState>, ActivesState> {

  // todo Все ассеты запрашиваются с гугл таблиц
  final List<String> assets = [
    'btcusdt',
    'ethusdt',
    'dogeusdt',
    'lrcusdt',
    'etcusdt',
    'apeusdt',
    'gmtusdt',
  ];

  final BaseBinanceDataService binanceRepository;

  final BaseGoogleSheetDataService googleSheetRepository;

  /// Все балансы. Хрнаятся для применения фильтров
  List<AppCryptoBalance> _allBalances = [];

  /// Все бинансовские валюты
  Map<String, SymbolData> binanceSymbolsMap = {};

  BinanceUserDataResponse? binanceUserDataResponse;
  // todo bybit
  // todo wallets

  ActivesState? get content  => state.getContent();

  double countFilterThresholdValue = 0.0;

  ActivesBloc(GlobalState<ActivesState> initialState, {
    required this.binanceRepository, required this.googleSheetRepository}) : super(initialState) {

    on<InitialEvent>(_onInitialEvent);
    on<RefreshPricesFromWSEvent>(_onRefreshPriceByWSEvent);
    on<RefreshPageEvent>(_onRefreshPageEvent);

  }

  Future<void> _onRefreshPageEvent(
      RefreshPageEvent event,
      Emitter<GlobalState<ActivesState>> emit) async {
    try {
      await _refreshData(emit, withFetch: true);
    } catch(e) {
      handleHttpException(e, emit, state.getContent()!);
    }

  }

  Future<void> _onInitialEvent(
      InitialEvent event,
      Emitter<GlobalState<ActivesState>> emit) async {

    emit(ActivesState(balances: []).toContent());
    try {
      await _refreshData(emit, withFetch: false);
    } catch(e) {
      handleHttpException(e, emit, state.getContent()!);
    }

  }

  Future<void> _refreshData(Emitter<GlobalState<ActivesState>> emit, {required bool withFetch}) async {
    await _refreshBinanceParams(emit, withFetch: withFetch);

  }

  /// Обновить данные, которые связаны с бинансом
  Future<void> _refreshBinanceParams(Emitter<GlobalState<ActivesState>> emit, {required bool withFetch}) async {
    binanceUserDataResponse = await binanceRepository.getAccountInformation(
      isRefresh: withFetch,
    );
    final appBalances = binanceUserDataResponse!.balances.map((e) =>
        AppCryptoBalance.fromBinanceBalance(e)).toList();

    _allBalances = appBalances;
    final filteredBalances = _applyFiltersToAllBalances(
        filters: [
          _balanceCountFilter,
        ]
    );
    //emit(state.getContent()!.copyWith(balances: filteredBalances).toContent());

    final binanceSymbols = await binanceRepository.getSymbolTickerData(
        isRefresh: withFetch);
    // Преобразовать котировки в мапу для быстрого поиска
    for (var i in binanceSymbols) {
      binanceSymbolsMap[i.symbol.toLowerCase()] = i;
    }
    // Обновить данные по стоимости крипты
    final currentBalancesList = filteredBalances;
    if (currentBalancesList.isEmpty) {
      return;
    }
    for(var i in currentBalancesList) {
      final balanceAsset = i.asset;
      final balanceAssetUSDT = balanceAsset.toLowerCase() + 'usdt';
      SymbolData? price;
      if (balanceAssetUSDT == 'usdtusdt') {
        price = SymbolData(price: '1.0', symbol: 'usdtusdt');
      } else {
        price = binanceSymbolsMap[balanceAssetUSDT];
      }
      assert(price != null, 'Прайс точно должен быть');
      i.setNewPrice(double.parse(price!.price));
    }

    emit(state.getContent()!.copyWith(balances: filteredBalances).toContent());
  }

  /// От вебсокета пришло обновление цен на крипту
  Future<void> _onRefreshPriceByWSEvent(
      RefreshPricesFromWSEvent event,
      Emitter<GlobalState<ActivesState>> emit) async {

    final currentBalancesList = state.getContent()?.balances;
    if (currentBalancesList?.isEmpty ?? true) {
      return;
    }
    final newPriceData = event.priceData;
    final newPriceAsset = newPriceData.symbol;
    for(var i in currentBalancesList!) {
      final balanceAsset = i.asset;
      if (balanceAsset.isEqualAsset(newPriceAsset)) {
        i.setNewPrice(double.parse(newPriceData.price));
      }
    }
    emit(state.getContent()!.copyWith(
      balances: currentBalancesList,
    ).toContent());
  }

  /// Запустить прослушку сокета
  void _initBinanceWebSocket() async {
    //await binanceRepository.initWebSocketChannel(symbols: assets);
    //binanceRepository.listenPricesChanged(_onMessageReceivedFormWs);
  }

  /// Принять сообщение с вебсокета
  void _onMessageReceivedFormWs(dynamic message) {
    final jsonMessage = jsonDecode(message) as Map<String, dynamic>;

    for(var i in assets) {

      final asset = jsonMessage['stream'];

      if (asset == null) continue;
      if (asset != i + '@aggTrade') continue;

      final streamData = jsonMessage['data'];

      if (streamData == null) continue;

      final assetData = AggTradeResponse.fromJson(streamData);

      add(RefreshPricesFromWSEvent(priceData: assetData));
    }
  }

  /// Применить фильтры [filters] к списку балансов [_allBalances]
  /// Вернёт новый список балансов
  List<AppCryptoBalance> _applyFiltersToAllBalances({
    required List<BalanceFilter> filters
  }) {
    final newList = <AppCryptoBalance>[];
    for(var b in _allBalances) {
      bool canAdd = true;
      for(var f in filters) {
        final res = f.call(b);
        if (!res) {
          canAdd = false;
          break;
        }
      }
      if (canAdd) {
        newList.add(b);
      }
    }
    return newList;
  }


  /// Фильтр баланса по количеству
  bool _balanceCountFilter(AppCryptoBalance b) {
    return b.count > countFilterThresholdValue;
  }

  @override
  Future<void> onInitialEvent(BaseInitialEvent event, Emitter<GlobalState<ActivesState>> emit) {
    // TODO: implement onInitialEvent
    throw UnimplementedError();
  }

  @override
  Future<void> onRefreshEvent(BaseRefreshEvent event, Emitter<GlobalState<ActivesState>> emit) async {
    add(RefreshPageEvent());
  }

}


typedef BalanceFilter = bool Function(AppCryptoBalance b);