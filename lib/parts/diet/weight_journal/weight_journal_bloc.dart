
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invests_helper/base/bloc_event_base.dart';
import 'package:invests_helper/base/bloc_state_base.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_bloc.dart';
import 'package:invests_helper/data/models/response/google_sheets/diet.dart';
import 'package:invests_helper/data/services/google_sheet/google_sheet_service_base.dart';
import 'package:invests_helper/parts/diet/weight_journal/weight_journal_event.dart';
import 'package:invests_helper/parts/diet/weight_journal/weight_journal_state.dart';

class WeightJournalBloc extends InvestHelperBloc<
    WeightJournalEvent,
    GlobalState<WeightJournalState>,
    WeightJournalState
> {

  BaseGoogleSheetDataService baseGoogleSheetDataService;

  WeightJournalBloc({required this.baseGoogleSheetDataService}) : super(LoadingStateBase()) {
    on<WeightJournalAddEntryEvent>(_onWeightJournalAddEntryEvent);
  }

  Future<void> _onWeightJournalAddEntryEvent(
      WeightJournalAddEntryEvent event,
      Emitter<GlobalState<WeightJournalState>> emit) async {

    final currentState = state.getContent() ?? WeightJournalState.empty();

    try {
      final entry = event.model;
      await baseGoogleSheetDataService.addWeightJournalEntry(entry: entry);
      emit(currentState.toContent());
      await _refresh(isRefresh: true, emit: emit);

    } catch(e) {
      handleHttpException(e, emit, currentState);
      emit(currentState.toContent());
    }
  }

  @override
  Future<void> onInitialEvent(BaseInitialEvent event, Emitter<GlobalState<WeightJournalState>> emit) async {
    await _refresh(isRefresh: false, emit: emit);
  }

  @override
  Future<void> onRefreshEvent(BaseRefreshEvent event, Emitter<GlobalState<WeightJournalState>> emit) async {
    await _refresh(isRefresh: true, emit: emit);
  }

  Future<void> _refresh({
    required bool isRefresh,
    required Emitter<GlobalState<WeightJournalState>> emit,
  }) async {
    final currentState = state.getContent() ?? WeightJournalState.empty();

    try {
      emit(currentState.copyWith(loading: true).toContent());
      final dietData = await baseGoogleSheetDataService.getAllDietData(
          isRefresh: isRefresh);

      final markersCount = buildMarkersCount<DietWeightJournalModel>(
          data: dietData.dietWeightJournal);

      emit(currentState.copyWith(
        markersCount: markersCount,
        users: buildMapFromList<DietUserModel>(data: dietData.dietUsers,),
        loading: false,
      ).toContent());

    } catch(e) {
      handleHttpException(e, emit, currentState);
      emit(currentState.toContent());
    }
  }


}