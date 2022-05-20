
import 'package:invests_helper/base/bloc_event_base.dart';

abstract class CreateOrderEvent extends GlobalEvent {

}

class CreateOrderEventInitialEvent extends CreateOrderEvent {

}

class WhereCreateOrderSelectedEvent extends CreateOrderEvent {
  final int selectedIndex;
  WhereCreateOrderSelectedEvent({required this.selectedIndex});
}

class AssetSelectedEvent extends CreateOrderEvent {
  final int selectedIndex;
  AssetSelectedEvent({required this.selectedIndex});
}

class HowBuyCryptoChangedEvent extends CreateOrderEvent {
  final double usdt;
  HowBuyCryptoChangedEvent({required this.usdt});
}

// Sells
class CreateOrderSellAddedEvent extends CreateOrderEvent {}

class CreateOrderSellDeletedEvent extends CreateOrderEvent {
  final int index;
  CreateOrderSellDeletedEvent({required this.index});
}

class CreateOrderProfitPercentChangedEvent extends CreateOrderEvent {
  final int index;
  final int value;
  CreateOrderProfitPercentChangedEvent({
    required this.index,
    required this.value,
  });
}

class CreateOrderSellPercentChangedEvent extends CreateOrderEvent {
  final int index;
  final int value;
  CreateOrderSellPercentChangedEvent({
    required this.index,
    required this.value,
  });
}

class CreateOrderNewOrderConfirmEvent extends CreateOrderEvent {

}


