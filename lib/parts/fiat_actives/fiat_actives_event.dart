
import 'package:invests_helper/base/bloc_event_base.dart';
import 'package:invests_helper/data/models/response/google_sheets/buys_cash.dart';

class FiatActivesEvent extends GlobalEvent {}

class FiatActivesCreateNewBuyEvent extends FiatActivesEvent {
  final BuysCash buysCash;
  FiatActivesCreateNewBuyEvent({required this.buysCash});
}