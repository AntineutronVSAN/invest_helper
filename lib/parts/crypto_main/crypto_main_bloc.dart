

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invests_helper/base/bloc_event_base.dart';
import 'package:invests_helper/base/bloc_state_base.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_bloc.dart';
import 'package:invests_helper/parts/crypto_main/crypto_main_event.dart';
import 'package:invests_helper/parts/crypto_main/crypto_main_state.dart';

class CryptoMainBloc extends InvestHelperBloc<
    CryptoMainEvent,
    GlobalState<CryptoMainState>,
    CryptoMainState> {

  CryptoMainBloc() : super(LoadingStateBase());

  @override
  Future<void> onInitialEvent(BaseInitialEvent event, Emitter<GlobalState<CryptoMainState>> emit) async {
    final firstState = CryptoMainState.empty();
    emit(firstState.toContent());
  }

  @override
  Future<void> onRefreshEvent(BaseRefreshEvent event, Emitter<GlobalState<CryptoMainState>> emit) async {
    emit(state.getContent()!.toContent());
  }

}