import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invests_helper/base/bloc_event_base.dart';
import 'package:invests_helper/base/bloc_state_base.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_bloc.dart';
import 'package:invests_helper/data/models/response/google_sheets/diet.dart';
import 'package:invests_helper/data/services/google_sheet/google_sheet_service_base.dart';
import 'package:invests_helper/parts/diet/diet_journal/diet_journal_event.dart';
import 'package:invests_helper/parts/diet/diet_journal/diet_journal_state.dart';
import 'package:invests_helper/utils/memory_cacher.dart';
import 'package:invests_helper/utils/time_service.dart';

class DietJournalBloc extends InvestHelperBloc<DietJournalEvent,
    GlobalState<DietJournalState>,
    DietJournalState> {
  final BaseGoogleSheetDataService baseGoogleSheetDataService;

  ///
  _DietJournalEntities? currentEntities;
  _DietJournalEntities? allEntities;

  final IHMemoryCacheSingleData dayStatisticsCache =
  IHMemoryCacheSingleData<DietJournalStatisticsData>();


  DietJournalBloc({required this.baseGoogleSheetDataService})
      : super(LoadingStateBase()) {
    on<DietJournalDaySelectedEvent>(_onDietJournalDaySelectedEvent);
    on<DietJournalAddNewEntryEvent>(_onDietJournalAddNewEntryEvent);
  }

  Future<void> _onDietJournalAddNewEntryEvent(DietJournalAddNewEntryEvent event,
      Emitter<GlobalState<DietJournalState>> emit) async {
    final currentState = state.getContent() ?? DietJournalState.empty();

    try {
      emit(currentState.copyWith(loading: true).toContent());
      await baseGoogleSheetDataService.addDietJournalEntry(entry: event.entry);
      emit(currentState.copyWith(loading: false).toContent());
      refreshEvent();
    } catch (e) {
      handleHttpException(e, emit, currentState);
    }
  }

  void selectDay({required DateTime selectedDay}) {
    add(DietJournalDaySelectedEvent(selectedDay: selectedDay));
  }

  Future<void> _onDietJournalDaySelectedEvent(DietJournalDaySelectedEvent event,
      Emitter<GlobalState<DietJournalState>> emit) async {
    final currentState = state.getContent() ?? DietJournalState.empty();

    final newDay = event.selectedDay;

    calculateStatistics(
        entities: currentEntities!,
        selectedDay: IHTimeService.onlyDayStr(dateTime: newDay),
        withRefresh: false,
    );

    emit(currentState.copyWith(
      selectedDay: event.selectedDay,
      statisticsData: currentEntities?.statisticsData,
    ).toContent());
  }

  Future<void> _refreshData({
    required bool isRefresh,
    required Emitter<GlobalState<DietJournalState>> emit,
  }) async {
    final currentState = state.getContent() ?? DietJournalState.empty();

    try {
      emit(currentState.copyWith(loading: true).toContent());

      await _loadAndCalculateEntities(
        isRefresh: isRefresh,
        selectedDay: currentState.selectedDay,
      );

      emit(currentState
          .copyWith(
        markersCount: currentEntities!.markersCount,
        users: buildMapFromList<DietUserModel>(
            data: currentEntities!.dietData.dietUsers),
        products: buildMapFromList<DietProductModel>(
            data: currentEntities!.dietData.dietProducts),
        loading: false,
        statisticsData: currentEntities!.statisticsData,
      )
          .toContent());
    } catch (e) {
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
  Future<void> onRefreshEvent(BaseRefreshEvent event,
      Emitter<GlobalState<DietJournalState>> emit) async {
    await _refreshData(isRefresh: true, emit: emit);
  }

  /// Подргузить все сущности, отфильтровать и просчитать всё что нужно
  Future<void> _loadAndCalculateEntities({
    required bool isRefresh,
    required DateTime selectedDay,
  }) async {
    if (isRefresh) {
      dayStatisticsCache.clear();
    }
    final dietData =
    await baseGoogleSheetDataService.getAllDietData(isRefresh: isRefresh);
    // Запоминаются все сущности
    allEntities = _DietJournalEntities(dietData: dietData);
    // Фильтр про списку юзеров
    currentEntities = _getEntitiesByUser(dietAllDataModel: dietData);

    calculateMarkersData(currentEntities!);
    calculateStatistics(
      entities: currentEntities!,
      selectedDay: IHTimeService.onlyDayStr(dateTime: selectedDay),
      withRefresh: isRefresh,
    );
  }

  /// Отфильтровать сущности по текущему юзеру
  _DietJournalEntities _getEntitiesByUser(
      {required DietAllDataModel dietAllDataModel}) {
    // TODO Фильтрация по юзеру
    return _DietJournalEntities(dietData: dietAllDataModel);
  }

  /// Посчитать для объекта [entities] данные для календаря
  void calculateMarkersData(_DietJournalEntities entities) {
    final markersCount = buildMarkersCount<DietJournalModel>(
        data: entities.dietData.dietJournal);
    entities.markersCount = markersCount;
  }

  /// осчитать для объекта [entities] статистические данные
  void calculateStatistics({
    required _DietJournalEntities entities,
    required String selectedDay,
    required bool withRefresh,
  }) {
    // Проверка на наличие в кеше
    /*if (!withRefresh) {
      final cache = dayStatisticsCache.get(key: dayStr);
      if (cache != null) {
        entities.statisticsData = cache;
        return;
      }
    }*/

    var totalKKal = 0.0;
    var totalPrice = 0.0;

    final Map<int, DietProductModel> _products = {};
    for(var i in entities.dietData.dietProducts) {
      _products[i.id] = i;
    }

    final currentDayEntries = entities.markersCount?[selectedDay] ?? [];
    for(var i in currentDayEntries) {
      final currentProduct = _products[i.productId];
      if (currentProduct == null) {
        print('WARNING: Продукт ${i.productId} не найден');
        continue;
      }
      totalKKal += currentProduct.kkal * i.weight / 100.0;
      totalPrice += currentProduct.price * i.weight / 100.0;

    }

    final statisticsData = DietJournalStatisticsData(
      totalKKal: totalKKal,
      totalRub: totalPrice,
    );

    /*dayStatisticsCache.add(
        key: dayStr,
        value: statisticsData
    );*/

    entities.statisticsData = statisticsData;
  }

}

/// Служебный объект для структуризации данных
class _DietJournalEntities {
  final DietAllDataModel dietData;

  DietJournalStatisticsData? statisticsData;
  Map<String, List<DietJournalModel>>? markersCount;

  _DietJournalEntities({
    required this.dietData,
  });
}
