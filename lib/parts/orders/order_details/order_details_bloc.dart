
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invests_helper/base/bloc_event_base.dart';
import 'package:invests_helper/base/bloc_state_base.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_bloc.dart';
import 'package:invests_helper/data/services/binance/binance_data_service_base.dart';
import 'package:invests_helper/parts/orders/order_details/order_details_event.dart';
import 'package:invests_helper/parts/orders/order_details/order_details_state.dart';

class OrderDetailsBloc extends InvestHelperBloc<OrderDetailsEvent, GlobalState<OrderDetailsState>,
    OrderDetailsState> {

  final BaseBinanceDataService binanceDataService;

  OrderDetailsBloc({required this.binanceDataService}) : super(LoadingStateBase());

  @override
  Future<void> onInitialEvent(BaseInitialEvent event, Emitter<GlobalState<OrderDetailsState>> emit) async {
    emit(OrderDetailsState.empty().toContent());
  }

  @override
  Future<void> onRefreshEvent(BaseRefreshEvent event, Emitter<GlobalState<OrderDetailsState>> emit) async {

  }


}