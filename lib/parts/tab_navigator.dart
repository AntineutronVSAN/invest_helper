import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:invests_helper/base/bloc_state_base.dart';
import 'package:invests_helper/const.dart';
import 'package:invests_helper/data/models/response/google_sheets/diet.dart';
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
import 'package:invests_helper/parts/diet/diet_journal/create_diet_entry/create_diet_entry_page.dart';
import 'package:invests_helper/parts/diet/diet_journal/diet_journal_bloc.dart';
import 'package:invests_helper/parts/diet/diet_journal/diet_journal_page.dart';
import 'package:invests_helper/parts/diet/diet_main_page/diet_main_bloc.dart';
import 'package:invests_helper/parts/diet/diet_main_page/diet_main_page.dart';
import 'package:invests_helper/parts/diet/weight_journal/create_weight_entry_page/create_weight_entry_page.dart';
import 'package:invests_helper/parts/diet/weight_journal/weight_journal_bloc.dart';
import 'package:invests_helper/parts/diet/weight_journal/weight_journal_page.dart';
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
  /* Все репозитории, в том числе и тестовые */
  static final BaseBinanceRepository productionBinanceRepository =
      BinanceRepository();
  static final BaseBinanceRepository testBinanceRepository =
      TestBinanceRepository();
  static final BaseGoogleSheetRepository prodGoogleRepo =
      GoogleSheetRepository();
  static final BaseGoogleSheetRepository testGoogleRepo =
      TestGoogleSheetRepository();

  /* Врапперы над репозиториями */
  static final BinanceDataService binanceDataService =
      BinanceDataService(binanceRepository: _binanceRepository);
  static final GoogleSheetDataService googleSheetDataService =
      GoogleSheetDataService(googleSheetRepository: _googleSheetRepository);

  /* Репозитории в зависимости от окружения */
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

  static Widget getDietMainPage() {
    final bloc = DietMainBloc(baseGoogleSheetDataService: googleSheetDataService);
    bloc.initEvent();
    final page = DietMainPage(bloc: bloc);
    return page;
  }

  static Widget getDietJournalPage() {
    final bloc = DietJournalBloc(baseGoogleSheetDataService: googleSheetDataService);
    bloc.initEvent();
    final page = DietJournalPage(bloc: bloc);
    return page;
  }

  static Widget getWeightJournalPage() {
    final bloc = WeightJournalBloc(baseGoogleSheetDataService: googleSheetDataService);
    bloc.initEvent();
    final page = WeightJournalPage(bloc: bloc);
    return page;
  }

  static Widget getCreateWeightEntryPage({
    required List<DietUserModel> users,
    required WeightJournalBloc weightJournalBloc
  }) {
    final key = GlobalKey<FormBuilderState>();
    final page = CreateWeightEntryPage(
      users: users,
      weightJournalBloc: weightJournalBloc,
      formKey: key,
    );
    return page;
  }

  static Widget getCreateDietJournalEntryPage({
    required List<DietUserModel> users,
    required List<DietProductModel> products,
    required DietJournalBloc dietJournalBloc,
  }) {
    final page = CreateDietEntryPage(
        users: users,
        products: products,
        dietJournalBloc: dietJournalBloc,
    );
    return page;
  }
}
