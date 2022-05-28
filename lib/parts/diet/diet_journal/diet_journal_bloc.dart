


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invests_helper/base/bloc_event_base.dart';
import 'package:invests_helper/base/bloc_state_base.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_bloc.dart';
import 'package:invests_helper/data/models/response/google_sheets/diet.dart';
import 'package:invests_helper/data/services/google_sheet/google_sheet_service_base.dart';
import 'package:invests_helper/parts/diet/diet_journal/diet_journal_event.dart';
import 'package:invests_helper/parts/diet/diet_journal/diet_journal_state.dart';
import 'package:invests_helper/utils/time_service.dart';

class DietJournalBloc extends InvestHelperBloc<
    DietJournalEvent,
    GlobalState<DietJournalState>,
    DietJournalState
> {

  final BaseGoogleSheetDataService baseGoogleSheetDataService;

  DietJournalBloc({required this.baseGoogleSheetDataService}) : super(LoadingStateBase()) {
    on<DietJournalDaySelectedEvent>(_onDietJournalDaySelectedEvent);
  }

  void selectDay({required DateTime selectedDay}) {
    add(DietJournalDaySelectedEvent(selectedDay: selectedDay));
  }

  Future<void> _onDietJournalDaySelectedEvent(
      DietJournalDaySelectedEvent event, Emitter<GlobalState<DietJournalState>> emit) async {

    final currentState = state.getContent() ?? DietJournalState.empty();
    emit(currentState.copyWith(
        selectedDay: event.selectedDay
    ).toContent());
  }

  Future<void> _refreshData({
    required bool isRefresh,
    required Emitter<GlobalState<DietJournalState>> emit,
  }) async {
    final currentState = state.getContent() ?? DietJournalState.empty();
    //emit(currentState.toContent());

    try {
      final dietData = await baseGoogleSheetDataService.getAllDietData(
          isRefresh: isRefresh);

      final markersCount = buildMarkersCount<DietJournalModel>(
          data: dietData.dietJournal);

      emit(currentState.copyWith(
        markersCount: markersCount,
        users: buildMapFromList<DietUserModel>(data: dietData.dietUsers),
        products: buildMapFromList<DietProductModel>(data: dietData.dietProducts),
      ).toContent());

    } catch(e) {
      handleHttpException(e, emit, currentState);
      emit(currentState.toContent());
    }
  }

  @override
  Future<void> onInitialEvent(BaseInitialEvent event,
      Emitter<GlobalState<DietJournalState>> emit) async {
    await _refreshData(isRefresh: false, emit: emit);
  }

  @override
  Future<void> onRefreshEvent(BaseRefreshEvent event, Emitter<GlobalState<DietJournalState>> emit) async {
    await _refreshData(isRefresh: true, emit: emit);
  }

}