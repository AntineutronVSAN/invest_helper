
import 'package:invests_helper/base/bloc_state_base.dart';
import 'package:invests_helper/data/models/response/google_sheets/diet.dart';
import 'package:invests_helper/utils/time_service.dart';

class WeightJournalState extends BaseState<WeightJournalState> {

  final DateTime selectedDay;
  final Map<String, List<DietWeightJournalModel>> markersCount;

  final Map<int, DietUserModel> users;

  final bool loading;

  WeightJournalState({
    required this.selectedDay,
    required this.markersCount,
    required this.users,
    this.loading = false,
  });

  factory WeightJournalState.empty() {
    return WeightJournalState(
      selectedDay: IHTimeService.getNow(),
      markersCount: {},
      users: {},
    );
  }

  WeightJournalState copyWith({
    DateTime? selectedDay,
    Map<String, List<DietWeightJournalModel>>? markersCount,
    Map<int, DietUserModel>? users,
    bool? loading,
  }) {
    return WeightJournalState(
      selectedDay: selectedDay ?? this.selectedDay,
      markersCount: markersCount ?? this.markersCount,
      users: users ?? this.users,
      loading: loading ?? false,
    );
  }

}