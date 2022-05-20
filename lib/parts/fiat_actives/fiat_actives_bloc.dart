
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invests_helper/base/bloc_event_base.dart';
import 'package:invests_helper/base/bloc_state_base.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_bloc.dart';
import 'package:invests_helper/data/models/response/google_sheets/buys_cash.dart';
import 'package:invests_helper/data/models/response/google_sheets/buys_cash_status.dart';
import 'package:invests_helper/data/services/google_sheet/google_sheet_service_base.dart';
import 'package:invests_helper/parts/fiat_actives/fiat_actives_event.dart';
import 'package:invests_helper/parts/fiat_actives/fiat_actives_state.dart';

class FiatActivesBloc extends InvestHelperBloc<FiatActivesEvent, GlobalState<FiatActivesState>,
    FiatActivesState> {

  final BaseGoogleSheetDataService googleSheetDataService;



  FiatActivesBloc({required this.googleSheetDataService}) : super(LoadingStateBase()) {
    on<FiatActivesCreateNewBuyEvent>(_onFiatActivesCreateNewBuyEvent);
  }

  Future<void> _onFiatActivesCreateNewBuyEvent(FiatActivesCreateNewBuyEvent event,
      Emitter<GlobalState<FiatActivesState>> emit) async {
    try {
      await googleSheetDataService.createNewFiatBuy(buy: event.buysCash);
      await Future.delayed(const Duration(seconds: 2));
      emit(state.getContent()!.toContent());
    } catch(e) {
      handleHttpException(e, emit, state.getContent() ?? FiatActivesState.empty());
    }
  }

  @override
  Future<void> onInitialEvent(BaseInitialEvent event,
      Emitter<GlobalState<FiatActivesState>> emit) async {
    final firstState = FiatActivesState.empty();

    try {
      final entities = await _loadAllEntities(isRefresh: false);
      emit(firstState.copyWith(
        buys: entities.buys,
        buysStatusesMap: Map.fromIterables(
            entities.buysCashStatus.map((e) => e.id), entities.buysCashStatus),
        info: entities.fiatActiveInformation,
      ).toContent());

    } catch(e) {
      handleHttpException(e, emit, firstState);
    }

  }

  @override
  Future<void> onRefreshEvent(BaseRefreshEvent event,
      Emitter<GlobalState<FiatActivesState>> emit) async {

    final currentState = state.getContent() ?? FiatActivesState.empty();

    try {
      final entities = await _loadAllEntities(isRefresh: true);
      emit(currentState.copyWith(
        buys: entities.buys,
        buysStatusesMap: Map.fromIterables(
            entities.buysCashStatus.map((e) => e.id), entities.buysCashStatus),
        info: entities.fiatActiveInformation,
      ).toContent());

    } catch(e) {
      handleHttpException(e, emit, currentState);
    }
  }


  FiatActiveInformation _getInformation({
    required List<BuysCash> buys,
  }) {

    final allAssetsMap = <String, bool>{};

    // Для рассчёта среднего курса по ассету
    final allAssetsBuyRub = <String, double>{};
    final allAssetsBuyAsset = <String, double>{};

    for(var b in buys) {
      final asset = b.pair;
      final hasKey = allAssetsMap.containsKey(asset);
      if (hasKey) {
        allAssetsMap[asset] = true;
        allAssetsBuyRub[asset] = allAssetsBuyRub[asset]! + b.count*b.course;
        allAssetsBuyAsset[asset] = allAssetsBuyAsset[asset]! + b.count;
        continue;
      }
      allAssetsMap[asset] = true;
      allAssetsBuyRub[asset] = b.count*b.course;
      allAssetsBuyAsset[asset] = b.count;
    }

    final assetsList = allAssetsMap.keys.toList();

    return FiatActiveInformation(
        assets: assetsList,
        assetSum: assetsList.map((e) {
          return allAssetsBuyAsset[e]!;
        }).toList(),
        meanCurse: assetsList.map((e) {
          return allAssetsBuyRub[e]! / allAssetsBuyAsset[e]!;
        }).toList(),
    );

  }

  Future<FiatActivesEntities> _loadAllEntities({required bool isRefresh}) async {
    final statuses = await googleSheetDataService.getBuysCashStatuses(
        isRefresh: isRefresh);
    final buys = await googleSheetDataService.getBuysCash(
        isRefresh: isRefresh);
    final info = _getInformation(buys: buys);
    return FiatActivesEntities(
        buys: buys,
        buysCashStatus: statuses,
        fiatActiveInformation: info
    );
  }

}

class FiatActivesEntities {
  final List<BuysCash> buys;
  final List<BuysCashStatus> buysCashStatus;
  final FiatActiveInformation fiatActiveInformation;
  FiatActivesEntities({
    required this.buys,
    required this.buysCashStatus,
    required this.fiatActiveInformation,
  });
}

class FiatActiveInformation {
  final List<String> assets;
  final List<double> assetSum;
  final List<double> meanCurse;
  FiatActiveInformation({
    required this.assets,
    required this.assetSum,
    required this.meanCurse,
  });

  factory FiatActiveInformation.empty() {
    return FiatActiveInformation(
        assets: [], assetSum: [], meanCurse: []);
  }
}