import 'package:flutter/material.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_stateless.dart';
import 'package:invests_helper/data/models/response/google_sheets/diet.dart';
import 'package:invests_helper/parts/diet/diet_journal/components/diet_list_item.dart';
import 'package:invests_helper/parts/diet/diet_journal/diet_journal_bloc.dart';
import 'package:invests_helper/parts/diet/diet_journal/diet_journal_event.dart';
import 'package:invests_helper/parts/diet/diet_journal/diet_journal_state.dart';
import 'package:invests_helper/parts/tab_navigator.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/app_bar/app_bar.dart';
import 'package:invests_helper/ui_package/app_button/app_button.dart';
import 'package:invests_helper/ui_package/app_calendar/app_calendar.dart';
import 'package:invests_helper/ui_package/app_pages/app_page_with_calendar_data.dart';
import 'package:invests_helper/ui_package/clicable_card/clicable_card.dart';
import 'package:invests_helper/ui_package/refresh_indicator/refresh_indicator.dart';
import 'package:invests_helper/utils/time_service.dart';
import 'package:table_calendar/table_calendar.dart';

class DietJournalPage extends InvestHelperStatelessWidget<DietJournalBloc,
    DietJournalEvent, DietJournalState> {
  const DietJournalPage({
    Key? key,
    required DietJournalBloc bloc,
  }) : super(bloc: bloc, key: key);

  @override
  void onListen(DietJournalState newState, BuildContext context) {
    // TODO: implement onListen
  }

  @override
  Widget onStateLoaded(DietJournalState newState, BuildContext context) {

    return IHWidgetWithBarCalendar<DietJournalModel>(
      calendarMarkersData: newState.markersCount,
      calendarListItemsBuilder: (context, item) {
        return DietListItem(
          entry: item,
          user: newState.users[item.userId]!,
          product: newState.products[item.productId]!,
        );
      },
      calendarSelectedDay: newState.selectedDay,
      calendarOnDaySelected: (start, end) {
        bloc.selectDay(selectedDay: start);
      },
      calendarMarkerBuilder: _getCalendarItemWidget,
      calendarLoading: newState.loading,

      onRefresh: () async {
        bloc.refreshEvent();
        await bloc.stream.first;
      },
      appBarBackgroundWidget: _getOverviewSection(state: newState, context: context),
      appBarBottomWidget: IHButton(
        //width: 100.0,
        text: 'Новая запись',
        onPressed: () {},
      ),
    );
  }

  Widget _getOverviewSection({
    required BuildContext context,
    required DietJournalState state,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IHCard(
          onPressed: () {},
          child: SizedBox(
            height: 120.0,
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: _getOverviewTexts(state: state, context: context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _getOverviewTexts({
    required BuildContext context,
    required DietJournalState state,
  }) {
    return [
      AppTexts.primaryInfoText(
          text: 'Что-то там',
          fontWeight: FontWeight.bold,
          fontSize: 17.0,
          padding: const EdgeInsets.symmetric(vertical: 2.0)),
      AppTexts.primaryInfoText(
          text: 'Что-то там',
          fontWeight: FontWeight.bold,
          fontSize: 17.0,
          padding: const EdgeInsets.symmetric(vertical: 2.0)),
      AppTexts.primaryInfoText(
          text: 'Что-то там',
          fontWeight: FontWeight.bold,
          fontSize: 17.0,
          padding: const EdgeInsets.symmetric(vertical: 2.0)),
      AppTexts.primaryInfoText(
          text: 'Что-то там',
          fontWeight: FontWeight.bold,
          fontSize: 17.0,
          padding: const EdgeInsets.symmetric(vertical: 2.0)),
      AppTexts.primaryInfoText(
          text: 'Что-то там',
          fontWeight: FontWeight.bold,
          fontSize: 17.0,
          padding: const EdgeInsets.symmetric(vertical: 2.0)),
      AppTexts.primaryInfoText(
          text: 'Что-то там',
          fontWeight: FontWeight.bold,
          fontSize: 17.0,
          padding: const EdgeInsets.symmetric(vertical: 2.0)),
      AppTexts.primaryInfoText(
          text: 'Что-то там',
          fontWeight: FontWeight.bold,
          fontSize: 17.0,
          padding: const EdgeInsets.symmetric(vertical: 2.0)),
      AppTexts.primaryInfoText(
          text: 'Что-то там',
          fontWeight: FontWeight.bold,
          fontSize: 17.0,
          padding: const EdgeInsets.symmetric(vertical: 2.0)),
    ];
  }

  Future<void> _onAddPressed({
    required BuildContext context,
    required DietJournalState state,
  }) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return TabNavigator.getCreateDietJournalEntryPage(
        users: state.users.values.toList(),
        products: state.products.values.toList(),
        dietJournalBloc: bloc,
      );
    }));
  }

  Widget? _getCalendarItemWidget(
      BuildContext context, DateTime dateTime, List<Object?> data) {
    if (data.isEmpty) return null;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _getRowOfEntryWidget(context: context, dateTime: dateTime, data: data)
      ],
    );
  }

  Widget _getRowOfEntryWidget(
      {required BuildContext context,
      required DateTime dateTime,
      required List<Object?> data}) {
    List<Widget> items = [];
    if (data.length <= 2) {
      for (var i in data) {
        items.add(_getCalendarEntryWidget());
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: items,
      );
    }

    for (var i = 0; i < 3; i++) {
      items.add(_getCalendarEntryWidget());
    }
    items.add(const Text(
      '+',
      style: TextStyle(color: AppColors.secondTextColor, fontSize: 15.0),
    ));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items,
    );
  }

  Widget _getCalendarEntryWidget() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.secondTextColor,
            borderRadius: BorderRadius.circular(2.0)),
        width: 5.0,
        height: 5.0,
      ),
    );
  }

  List<DietJournalModel> _getSelectedDayWidget({
    required DateTime dateTime,
    required DietJournalState state,
  }) {
    final dateTimeStrDay = IHTimeService.onlyDayStr(dateTime: dateTime);
    final hasKey = state.markersCount.containsKey(dateTimeStrDay);
    if (!hasKey) {
      return [];
    }
    return state.markersCount[dateTimeStrDay]!;
  }
}
