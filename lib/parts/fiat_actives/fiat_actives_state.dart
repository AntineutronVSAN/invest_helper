
import 'package:invests_helper/base/bloc_state_base.dart';
import 'package:invests_helper/data/models/response/google_sheets/buys_cash.dart';
import 'package:invests_helper/data/models/response/google_sheets/buys_cash_status.dart';
import 'package:invests_helper/parts/fiat_actives/fiat_actives_bloc.dart';

class FiatActivesState extends BaseState<FiatActivesState> {

  /// Какие есть статусы покупок фиата
  final Map<int, BuysCashStatus> buysStatusesMap;
  /// Все покупки
  final List<BuysCash> buys;
  /// Статистическая информация
  final FiatActiveInformation info;

  FiatActivesState({
    required this.buysStatusesMap,
    required this.buys,
    required this.info,
  });

  FiatActivesState copyWith({
    Map<int, BuysCashStatus>? buysStatusesMap,
    List<BuysCash>? buys,
    FiatActiveInformation? info,
  }) {
    return FiatActivesState(
      buysStatusesMap: buysStatusesMap ?? this.buysStatusesMap,
      buys: buys ?? this.buys,
      info: info ?? this.info,
    );
  }

  factory FiatActivesState.empty() {
    return FiatActivesState(
        buysStatusesMap: {},
        buys: [],
        info: FiatActiveInformation.empty(),
    );
  }

}