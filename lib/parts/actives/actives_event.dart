

import 'package:invests_helper/base/bloc_event_base.dart';
import 'package:invests_helper/data/models/response/binance/web_socket_models.dart';

abstract class ActivesEvent extends GlobalEvent {

}


class InitialEvent extends ActivesEvent {

}

class RefreshPricesFromWSEvent extends ActivesEvent {
  final AggTradeResponse priceData;
  RefreshPricesFromWSEvent({required this.priceData});
}

class RefreshPageEvent extends ActivesEvent {

}