import 'package:invests_helper/base/bloc_event_base.dart';
import 'package:invests_helper/data/models/response/google_sheets/google_sheet_order.dart';

abstract class OrdersEvent extends GlobalEvent {}

class OrdersInitialEvent extends OrdersEvent {}

class RefreshOrdersEvent extends OrdersEvent {}

class OrdersPageOrderSelected extends OrdersEvent {
  final GoogleSheetOrder order;
  OrdersPageOrderSelected({required this.order});
}

/// Усреднить ордера
class OrdersPageMeanOrderEvent extends OrdersEvent {
  final List<bool> selectedOrders;
  OrdersPageMeanOrderEvent({required this.selectedOrders});
}