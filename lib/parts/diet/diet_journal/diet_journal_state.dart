
import 'package:invests_helper/base/bloc_state_base.dart';
import 'package:invests_helper/data/models/response/google_sheets/diet.dart';
import 'package:invests_helper/utils/time_service.dart';

class DietJournalState extends BaseState<DietJournalState> {

  final DateTime selectedDay;
  final Map<String, List<DietJournalModel>> markersCount;

  final Map<int, DietUserModel> users;
  final Map<int, DietProductModel> products;

  DietJournalState({
    required this.selectedDay,
    required this.markersCount,
    required this.users,
    required this.products,
  });

  factory DietJournalState.empty() {
    return DietJournalState(
      selectedDay: IHTimeService.getNow(),
      markersCount: {},
      users: {},
      products: {},
    );
  }

  DietJournalState copyWith({
    DateTime? selectedDay,
    Map<String, List<DietJournalModel>>? markersCount,
    Map<int, DietUserModel>? users,
    Map<int, DietProductModel>? products,
  }) {
    return DietJournalState(
      selectedDay: selectedDay ?? this.selectedDay,
      markersCount: markersCount ?? this.markersCount,
      users: users ?? this.users,
      products: products ?? this.products,
    );
  }
}