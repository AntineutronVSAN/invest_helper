

import 'package:flutter/material.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_stateless.dart';
import 'package:invests_helper/parts/fiat_main/fiat_page_bloc.dart';
import 'package:invests_helper/parts/fiat_main/fiat_page_event.dart';
import 'package:invests_helper/parts/fiat_main/fiat_page_state.dart';
import 'package:invests_helper/parts/tab_navigator.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/app_bar/app_bar.dart';
import 'package:invests_helper/ui_package/refresh_indicator/refresh_indicator.dart';
import 'package:invests_helper/ui_package/selectable_item/selectable_item.dart';

class FiatPage extends InvestHelperStatelessWidget<
    FiatPageBloc,
    FiatPageEvent,
    FiatPageState
> {

  const FiatPage({
    required FiatPageBloc bloc,
    Key? key,
  }) : super(bloc: bloc, key: key);

  @override
  void onListen(FiatPageState newState, BuildContext context) {
    // TODO: implement onListen
  }

  @override
  Widget onStateLoaded(FiatPageState newState, BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: iHAppBar(title: 'Валюта'),
        backgroundColor: AppColors.primaryColor,
        body: AppRefreshIndicator(
          onRefresh: () async {
            bloc.refreshEvent();
            await bloc.stream.first;
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  _getBuysWidgetSection(context: context),
                  _getSpendsWidgetSection(context: context),
                  _getIncomesWidgetSection(context: context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getBuysWidgetSection({required BuildContext context}) {
    return SelectableItem(
      title: 'Покупки валюты',
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return TabNavigator.getFiatActivesScreen();
        }));
      },
      icon: const Icon(
        Icons.description,
        color: AppColors.secondColor,
      ),
    );
  }

  Widget _getSpendsWidgetSection({required BuildContext context}) {
    return const SelectableItem(
      title: 'Затраты',
      icon: Icon(
        Icons.description,
        color: AppColors.secondColor,
      ),
    );
  }

  Widget _getIncomesWidgetSection({required BuildContext context}) {
    return const SelectableItem(
      title: 'Доходы',
      icon: Icon(
        Icons.description,
        color: AppColors.secondColor,
      ),
    );
  }

}