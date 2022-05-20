

import 'package:invests_helper/base/bloc_state_base.dart';

class OrderDetailsState extends BaseState<OrderDetailsState> {

  OrderDetailsState();

  OrderDetailsState copyWith() {
    return OrderDetailsState();
  }

  factory OrderDetailsState.empty() {
    return OrderDetailsState();
  }

}