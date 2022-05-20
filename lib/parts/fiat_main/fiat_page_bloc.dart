

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invests_helper/base/bloc_event_base.dart';
import 'package:invests_helper/base/bloc_state_base.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_bloc.dart';
import 'package:invests_helper/parts/fiat_main/fiat_page_event.dart';
import 'package:invests_helper/parts/fiat_main/fiat_page_state.dart';

class FiatPageBloc extends InvestHelperBloc<
    FiatPageEvent,
    GlobalState<FiatPageState>,
    FiatPageState
> {

  FiatPageBloc() : super(LoadingStateBase());

  @override
  Future<void> onInitialEvent(BaseInitialEvent event,
      Emitter<GlobalState<FiatPageState>> emit) async {
    emit(FiatPageState.empty().toContent());
  }

  @override
  Future<void> onRefreshEvent(BaseRefreshEvent event,
      Emitter<GlobalState<FiatPageState>> emit) async {

  }

}