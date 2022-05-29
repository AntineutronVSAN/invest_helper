
import 'package:flutter/material.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/app_button/app_button.dart';
import 'package:invests_helper/ui_package/loading_widget/loading_widget.dart';
import 'package:invests_helper/ui_package/not_found/not_found.dart';
import 'package:invests_helper/utils/time_service.dart';
import 'package:table_calendar/table_calendar.dart';


class IHCalendarWithList<T> extends StatefulWidget {

  final DateTime? focusedDay;
  final DateTime? selectedDay;
  final Function(DateTime, DateTime)? onDaySelected;

  final Widget Function(BuildContext, T) listItemsBuilder;

  final Widget? Function(BuildContext, DateTime, List<Object?> data)? markerBuilder;
  final bool loading;

  /// Данные по каждому дню
  /// Ключ - дата и время в виде строки с НУЛЕВЫМ временем
  /// Значение - список объектов для данной даты
  final Map<String, List<T>> markersData;

  const IHCalendarWithList({
    Key? key,
    this.focusedDay,
    this.onDaySelected,
    this.selectedDay,
    this.markerBuilder,
    required this.markersData,
    required this.listItemsBuilder,
    this.loading = false,
  }) : super(key: key);

  @override
  State<IHCalendarWithList> createState() => _IHCalendarWithListState<T>();
}

class _IHCalendarWithListState<T> extends State<IHCalendarWithList<T>> {

  DateTime? focusedDay;
  DateTime? selectedDay;

  @override
  void initState() {

    focusedDay = widget.focusedDay ?? IHTimeService.getNow();
    selectedDay = widget.selectedDay ?? IHTimeService.getNow();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.loading)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppLoadingsWidget.getWidgetLoadingWidget(),
          ),
        _getCalendar(),
        const SizedBox(height: 25.0,),
        _getList(),
      ],
    );
  }

  Widget _getList() {

    final dateKey = IHTimeService.onlyDayStr(dateTime: selectedDay!);
    final items = widget.markersData[dateKey];
    if (items == null) {
      return const IHNotFound();
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        if (index == items.length - 1) {
          return Column(
            children: [
              widget.listItemsBuilder(context, items[index]),
              const SizedBox(height: 100.0,),
            ],
          );

        }
        return widget.listItemsBuilder(context, items[index]);
      },
    );
  }

  Widget _getCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: selectedDay!,
      onDaySelected: (start, end) {
        widget.onDaySelected?.call(start, end);
        setState(() {
          selectedDay = start;
        });
      },
      selectedDayPredicate: (day) {
        if (day.isAtSameMomentAs(selectedDay!)) {
          return true;
        }
        return false;
      },
      eventLoader: (dateTime) {
        return _getSelectedDayWidget(dateTime: dateTime);
      },
      calendarBuilders: CalendarBuilders(
          markerBuilder: widget.markerBuilder,
      ),
      calendarStyle: const CalendarStyle(
        markersMaxCount: 3,
        defaultTextStyle: TextStyle(
          color: AppColors.primaryTextColor,
        ),
      ),
    );
  }

  List<T> _getSelectedDayWidget({
    required DateTime dateTime,
  }) {
    final dateTimeStrDay = IHTimeService.onlyDayStr(dateTime: dateTime);
    final hasKey = widget.markersData.containsKey(dateTimeStrDay);
    if (!hasKey) {
      return [];
    }
    return widget.markersData[dateTimeStrDay]!;
  }

}
