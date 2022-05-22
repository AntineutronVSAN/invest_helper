
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

  /// Доступные для выбора валюты
  final List<String> fiatCurrencies;

  FiatActivesState({
    required this.buysStatusesMap,
    required this.buys,
    required this.info,
    required this.fiatCurrencies,
  });

  FiatActivesState copyWith({
    Map<int, BuysCashStatus>? buysStatusesMap,
    List<BuysCash>? buys,
    FiatActiveInformation? info,
    List<String>? fiatCurrencies,
  }) {
    return FiatActivesState(
      buysStatusesMap: buysStatusesMap ?? this.buysStatusesMap,
      buys: buys ?? this.buys,
      info: info ?? this.info,
      fiatCurrencies: fiatCurrencies ?? this.fiatCurrencies,
    );
  }

  factory FiatActivesState.empty() {
    return FiatActivesState(
        buysStatusesMap: {},
        buys: [],
        info: FiatActiveInformation.empty(),
        fiatCurrencies: ["usd", "eur", "rub"],
    );
  }

}