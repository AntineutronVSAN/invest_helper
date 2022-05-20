

import 'package:flutter/material.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_stateless.dart';
import 'package:invests_helper/parts/main_page/home_page_bloc.dart';
import 'package:invests_helper/parts/main_page/home_page_event.dart';
import 'package:invests_helper/parts/main_page/home_page_state.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/app_bar/app_bar.dart';
import 'package:invests_helper/ui_package/refresh_indicator/refresh_indicator.dart';

class MainTabPage extends InvestHelperStatelessWidget<
    HomePageBloc,
    HomePageEvent,
    HomePageState
> {

  const MainTabPage({required HomePageBloc bloc, Key? key}) : super(bloc: bloc, key: key);

  @override
  void onListen(HomePageState newState, BuildContext context) {
    // TODO: implement onListen
  }

  @override
  Widget onStateLoaded(HomePageState newState, BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: iHAppBar(title: 'Главная страница'),
        backgroundColor: AppColors.primaryColor,
        body: AppRefreshIndicator(
          onRefresh: () async {
            bloc.refreshEvent();
            await bloc.stream.first;
          },
          child: const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(15.0),
            ),
          ),
        ),
      ),
    );
  }

}