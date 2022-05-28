
import 'package:invests_helper/base/bloc_event_base.dart';
import 'package:invests_helper/data/models/response/google_sheets/diet.dart';

class WeightJournalEvent extends GlobalEvent {}

class WeightJournalAddEntryEvent extends WeightJournalEvent {
  final DietWeightJournalModel model;
  WeightJournalAddEntryEvent({required this.model});
}