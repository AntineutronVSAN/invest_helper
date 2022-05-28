import 'package:flutter/material.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_stateless.dart';
import 'package:invests_helper/data/models/response/google_sheets/diet.dart';
import 'package:invests_helper/parts/diet/weight_journal/components/weight_list_item.dart';
import 'package:invests_helper/parts/diet/weight_journal/weight_journal_bloc.dart';
import 'package:invests_helper/parts/diet/weight_journal/weight_journal_event.dart';
import 'package:invests_helper/parts/diet/weight_journal/weight_journal_state.dart';
import 'package:invests_helper/parts/tab_navigator.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/app_bar/app_bar.dart';
import 'package:invests_helper/ui_package/app_button/app_button.dart';
import 'package:invests_helper/ui_package/app_calendar/app_calendar.dart';
import 'package:invests_helper/ui_package/refresh_indicator/refresh_indicator.dart';

class WeightJournalPage extends InvestHelperStatelessWidget<WeightJournalBloc,
    WeightJournalEvent, WeightJournalState> {
  const WeightJournalPage({Key? key, required WeightJournalBloc bloc})
      : super(bloc: bloc, key: key);

  @override
  void onListen(WeightJournalState newState, BuildContext context) {
    // TODO: implement onListen
  }

  @override
  Widget onStateLoaded(WeightJournalState newState, BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: iHAppBar(
            title: 'Дневник веса',
            onBackTap: () {
              Navigator.of(context).pop();
            }),
        backgroundColor: AppColors.primaryColor,
        body: AppRefreshIndicator(
          onRefresh: () async {
            bloc.refreshEvent();
            await bloc.stream.first;
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Stack(
              children: [
                _getCalendar(state: newState, context: context, size: size),
                _getButtons(context: context, state: newState),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getButtons({
    required BuildContext context,
    required WeightJournalState state,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor.withOpacity(0.1),
              AppColors.primaryColor.withOpacity(0.8),
              AppColors.primaryColor.withOpacity(1.0),
            ],
          )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IHButton(
                text: 'Добавить запись',
                onPressed: () async {
                  await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return TabNavigator.getCreateWeightEntryPage(
                        users: state.users.values.toList(),
                        weightJournalBloc: bloc,
                    );
                  }));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getCalendar({
    required BuildContext context,
    required WeightJournalState state,
    required Size size,
  }) {
    return SizedBox(
      height: size.height,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: IHCalendarWithList<DietWeightJournalModel>(
          markersData: state.markersCount,
          listItemsBuilder: (context, item) {
            return WeightListItem(
              entry: item,
              user: state.users[item.userId]!,
            );
          },
          selectedDay: state.selectedDay,
          onDaySelected: (start, end) {
            //bloc.selectDay(selectedDay: start);
          },
          markerBuilder: _getCalendarItemWidget,
          loading: state.loading,
        ),
      ),
    );
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
}
