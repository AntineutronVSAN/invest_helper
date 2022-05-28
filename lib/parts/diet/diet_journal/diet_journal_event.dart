
import 'package:invests_helper/base/bloc_event_base.dart';
import 'package:invests_helper/data/models/response/google_sheets/diet.dart';

class DietJournalEvent extends GlobalEvent {}

class DietJournalDaySelectedEvent extends DietJournalEvent {
  final DateTime selectedDay;
  DietJournalDaySelectedEvent({required this.selectedDay});
}

class DietJournalAddNewEntryEvent extends DietJournalEvent {
  final DietJournalModel entry;
  DietJournalAddNewEntryEvent({required this.entry});
}