

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invests_helper/base/bloc_event_base.dart';
import 'package:invests_helper/base/bloc_state_base.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_bloc.dart';
import 'package:invests_helper/parts/main_page/home_page_event.dart';
import 'package:invests_helper/parts/main_page/home_page_state.dart';

class HomePageBloc extends InvestHelperBloc<
    HomePageEvent,
    GlobalState<HomePageState>,
    HomePageState
> {
  HomePageBloc() : super(LoadingStateBase());

  @override
  Future<void> onInitialEvent(BaseInitialEvent event,
      Emitter<GlobalState<HomePageState>> emit) async {

  }

  @override
  Future<void> onRefreshEvent(BaseRefreshEvent event,
      Emitter<GlobalState<HomePageState>> emit) async {

  }

}