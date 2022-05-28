

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invests_helper/base/bloc_event_base.dart';
import 'package:invests_helper/base/bloc_state_base.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_bloc.dart';
import 'package:invests_helper/data/services/google_sheet/google_sheet_service_base.dart';
import 'package:invests_helper/parts/diet/diet_main_page/diet_main_event.dart';
import 'package:invests_helper/parts/diet/diet_main_page/diet_main_state.dart';

class DietMainBloc extends InvestHelperBloc<
    DietMainEvent,
    GlobalState<DietMainState>,
    DietMainState
> {

  final BaseGoogleSheetDataService baseGoogleSheetDataService;

  DietMainBloc({
    required this.baseGoogleSheetDataService,
  }) : super(LoadingStateBase());

  @override
  Future<void> onInitialEvent(BaseInitialEvent event, Emitter<GlobalState<DietMainState>> emit) async {
    final curState =  state.getContent() ?? DietMainState.empty();
    emit(curState.toContent());
    try {
      final data = await baseGoogleSheetDataService.getAllDietData(isRefresh: true);
      emit(curState.toContent());
    } catch(e) {
      handleHttpException(e, emit, curState);
      emit(curState.toContent());
    }
  }

  @override
  Future<void> onRefreshEvent(BaseRefreshEvent event, Emitter<GlobalState<DietMainState>> emit) async {
    final curState =  state.getContent() ?? DietMainState.empty();
    try {
      final data = await baseGoogleSheetDataService.getAllDietData(isRefresh: true);
      emit(curState.toContent());
    } catch(e) {
      handleHttpException(e, emit, curState);
      emit(curState.toContent());
    }
  }

}