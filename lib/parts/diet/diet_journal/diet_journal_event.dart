
import 'package:invests_helper/base/bloc_event_base.dart';

class DietJournalEvent extends GlobalEvent {}

class DietJournalDaySelectedEvent extends DietJournalEvent {
  final DateTime selectedDay;
  DietJournalDaySelectedEvent({required this.selectedDay});
}