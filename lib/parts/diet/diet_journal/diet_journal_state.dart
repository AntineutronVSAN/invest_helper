
import 'package:invests_helper/base/bloc_state_base.dart';
import 'package:invests_helper/data/models/response/google_sheets/diet.dart';
import 'package:invests_helper/utils/time_service.dart';

class DietJournalState extends BaseState<DietJournalState> {

  final DateTime selectedDay;
  final Map<String, List<DietJournalModel>> markersCount;

  final Map<int, DietUserModel> users;
  final Map<int, DietProductModel> products;

  final DietJournalStatisticsData? statisticsData;

  final bool loading;

  DietJournalState({
    required this.selectedDay,
    required this.markersCount,
    required this.users,
    required this.products,
    this.loading = false,
    this.statisticsData,
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
    bool? loading,
    DietJournalStatisticsData? statisticsData,
  }) {
    return DietJournalState(
      selectedDay: selectedDay ?? this.selectedDay,
      markersCount: markersCount ?? this.markersCount,
      users: users ?? this.users,
      products: products ?? this.products,
      loading: loading ?? false,
      statisticsData: statisticsData ?? this.statisticsData,
    );
  }
}

class DietJournalStatisticsData {
  final double sadfasdf = 10.0;
  final double sasddfasdf = 20.0;
  final double sadffdasdf = 30.0;
  final double sadfadgfsdf = 40.0;
}