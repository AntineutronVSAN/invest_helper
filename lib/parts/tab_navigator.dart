import 'package:flutter/material.dart';
import 'package:invests_helper/base/bloc_state_base.dart';
import 'package:invests_helper/const.dart';
import 'package:invests_helper/data/models/response/google_sheets/google_sheet_order.dart';
import 'package:invests_helper/data/repositories/binance/base_binance_repository.dart';
import 'package:invests_helper/data/repositories/binance/binance_repository.dart';
import 'package:invests_helper/data/repositories/binance/test_binance_repository.dart';
import 'package:invests_helper/data/repositories/google_sheet/base_google_sheet_repo.dart';
import 'package:invests_helper/data/repositories/google_sheet/google_sheet_repo.dart';
import 'package:invests_helper/data/repositories/google_sheet/test_google_shet_repo.dart';
import 'package:invests_helper/data/services/binance/binance_data_service.dart';
import 'package:invests_helper/data/services/google_sheet/google_sheet_service.dart';
import 'package:invests_helper/main.dart';
import 'package:invests_helper/parts/actives/actives_bloc.dart';
import 'package:invests_helper/parts/actives/actives_screen.dart';
import 'package:invests_helper/parts/crypto_main/crypto_main_page.dart';
import 'package:invests_helper/parts/fiat_actives/create_fiat_buy/create_fiat_buy.dart';
import 'package:invests_helper/parts/fiat_actives/fiat_actives_bloc.dart';
import 'package:invests_helper/parts/fiat_actives/fiat_actives_page.dart';
import 'package:invests_helper/parts/fiat_main/fiat_page.dart';
import 'package:invests_helper/parts/fiat_main/fiat_page_bloc.dart';
import 'package:invests_helper/parts/main_page/home_page_bloc.dart';
import 'package:invests_helper/parts/main_page/home_page_page.dart';
import 'package:invests_helper/parts/orders/create_order_page/create_order_page.dart';
import 'package:invests_helper/parts/orders/order_details/order_details_bloc.dart';
import 'package:invests_helper/parts/orders/order_details/order_details_event.dart';
import 'package:invests_helper/parts/orders/order_details/order_details_page.dart';
import 'package:invests_helper/parts/orders/orders_bloc.dart';
import 'package:invests_helper/parts/orders/orders_page.dart';
import 'package:invests_helper/parts/orders/orders_state.dart';

import 'actives/actives_event.dart';
import 'crypto_main/crypto_main_bloc.dart';
import 'orders/create_order_page/create_order_bloc.dart';
import 'orders/create_order_page/create_order_event.dart';
import 'orders/orders_event.dart';

class TabNavigator {
  /* ?????? ??????????????????????, ?? ?????? ?????????? ?? ???????????????? */
  static final BaseBinanceRepository productionBinanceRepository =
      BinanceRepository();
  static final BaseBinanceRepository testBinanceRepository =
      TestBinanceRepository();
  static final BaseGoogleSheetRepository prodGoogleRepo =
      GoogleSheetRepository();
  static final BaseGoogleSheetRepository testGoogleRepo =
      TestGoogleSheetRepository();

  /* ???????????????? ?????? ?????????????????????????? */
  static final BinanceDataService binanceDataService =
      BinanceDataService(binanceRepository: _binanceRepository);
  static final GoogleSheetDataService googleSheetDataService =
      GoogleSheetDataService(googleSheetRepository: _googleSheetRepository);

  /* ?????????????????????? ?? ?????????????????????? ???? ?????????????????? */
  static BaseBinanceRepository get _binanceRepository =>
      AppConst.useTestBinanceRepository
          ? testBinanceRepository
          : productionBinanceRepository;

  static BaseGoogleSheetRepository get _googleSheetRepository =>
      AppConst.useTestBinanceRepository
          ? prodGoogleRepo // todo
          : prodGoogleRepo;

  static Widget getActivesScreen() {
    final bloc = ActivesBloc(
      LoadingStateBase(),
      binanceRepository: binanceDataService,
      googleSheetRepository: googleSheetDataService,
    );
    bloc.add(InitialEvent());
    return ActivesScreen(bloc: bloc);
  }

  static Widget getOrdersScreen() {
    final bloc = OrdersBloc(
        googleSheetRepository: googleSheetDataService,
        binanceRepository: binanceDataService);
    bloc.add(OrdersInitialEvent());
    return OrdersScreen(bloc: bloc);
  }

  static Widget getCreateOrderPage() {
    final bloc = CreateOrderBloc(
      binanceRepository: binanceDataService,
      googleSheetDataService: googleSheetDataService,
    );
    bloc.add(CreateOrderEventInitialEvent());
    return CreateOrderPage(bloc: bloc);
  }

  static Widget getOrderDetailsPage({
    required GoogleSheetOrder order,
    required double currentCurse,
    required List<SellPieceInfo> sellPieceInfo,
  }) {
    final bloc = OrderDetailsBloc(binanceDataService: binanceDataService);
    bloc.initEvent();
    final page = OrderDetailsPage(
      bloc: bloc,
      order: order,
      currentCurse: currentCurse,
      sellPieceInfo: sellPieceInfo,
    );
    return page;
  }

  static Widget getFiatActivesScreen() {
    final bloc =
        FiatActivesBloc(googleSheetDataService: googleSheetDataService);
    bloc.initEvent();
    final page = FiatActivePage(bloc: bloc);
    return page;
  }

  static Widget getCryptoMainPage() {
    final bloc = CryptoMainBloc();
    bloc.initEvent();
    final page = CryptoMainPage(bloc: bloc);
    return page;
  }

  static Widget getHomePage() {
    final bloc = HomePageBloc();
    bloc.initEvent();
    final page = MainTabPage(bloc: bloc,);
    return page;
  }

  static Widget getFiatPage() {
    final bloc = FiatPageBloc();
    bloc.initEvent();
    final page = FiatPage(bloc: bloc);
    return page;
  }

  static Widget getCreateBuyPage({
    required List<String> assets,
    required List<String> whereKeep,
    required FiatActivesBloc fiatActivesBloc,
}) {
    return CreateFiatByPage(
      assets: assets,
      whereKeep: whereKeep,
      fiatActivesBloc: fiatActivesBloc,
    );
  }

}
