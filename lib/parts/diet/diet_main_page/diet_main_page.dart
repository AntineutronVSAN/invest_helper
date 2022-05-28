import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_stateless.dart';
import 'package:invests_helper/parts/diet/diet_main_page/diet_main_bloc.dart';
import 'package:invests_helper/parts/diet/diet_main_page/diet_main_event.dart';
import 'package:invests_helper/parts/diet/diet_main_page/diet_main_state.dart';
import 'package:invests_helper/parts/tab_navigator.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/app_bar/app_bar.dart';
import 'package:invests_helper/ui_package/refresh_indicator/refresh_indicator.dart';
import 'package:invests_helper/ui_package/selectable_item/selectable_item.dart';

class DietMainPage extends InvestHelperStatelessWidget<DietMainBloc,
    DietMainEvent, DietMainState> {
  DietMainPage({Key? key, required DietMainBloc bloc})
      : super(bloc: bloc, key: key);

  @override
  void onListen(DietMainState newState, BuildContext context) {
    // TODO: implement onListen
  }

  @override
  Widget onStateLoaded(DietMainState newState, BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: iHAppBar(
          title: 'Диета, здоровье',
        ),
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
                  _getJournalItem(context: context),
                  _getWeightJournalItem(context: context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getJournalItem({
    required BuildContext context,
  }) {
    return SelectableItem(
      title: 'Дневник диеты',
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return TabNavigator.getDietJournalPage();
        }));
      },
      icon: const Icon(
        Icons.description,
        color: AppColors.secondColor,
      ),
    );
  }

  Widget _getWeightJournalItem({
    required BuildContext context,
  }) {
    return SelectableItem(
      title: 'Дневник веса',
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return TabNavigator.getWeightJournalPage();
        }));
      },
      icon: const Icon(
        Icons.description,
        color: AppColors.secondColor,
      ),
    );
  }
}
