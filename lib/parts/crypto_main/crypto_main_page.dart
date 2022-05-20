

import 'package:flutter/material.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_stateless.dart';
import 'package:invests_helper/parts/crypto_main/crypto_main_bloc.dart';
import 'package:invests_helper/parts/crypto_main/crypto_main_event.dart';
import 'package:invests_helper/parts/crypto_main/crypto_main_state.dart';
import 'package:invests_helper/parts/tab_navigator.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/app_bar/app_bar.dart';
import 'package:invests_helper/ui_package/refresh_indicator/refresh_indicator.dart';
import 'package:invests_helper/ui_package/selectable_item/selectable_item.dart';

class CryptoMainPage extends InvestHelperStatelessWidget<
    CryptoMainBloc,
    CryptoMainEvent,
    CryptoMainState
> {

  const CryptoMainPage({required CryptoMainBloc bloc, Key? key}) : super(bloc: bloc, key: key);

  @override
  void onListen(CryptoMainState newState, BuildContext context) {
    // TODO: implement onListen
  }

  @override
  Widget onStateLoaded(CryptoMainState newState, BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: iHAppBar(title: 'Криптовалюта'),
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
                  _getOurOrdersWidget(context: context),
                  _getBinanceActivesItem(context: context),
                  _getByBitActivesItem(context: context),
                  _getKuCoinActivesItem(context: context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getOurOrdersWidget({required BuildContext context}) {
    return SelectableItem(
      title: 'Наши ордера',
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return TabNavigator.getOrdersScreen();
        }));
      },
      icon: const Icon(
        Icons.description,
        color: AppColors.secondColor,
      ),
    );
  }

  Widget _getBinanceActivesItem({required BuildContext context}) {
    return SelectableItem(
      title: 'Активы Binance',
      icon: const Icon(
        Icons.description,
        color: AppColors.secondColor,
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return TabNavigator.getActivesScreen();
        }));
      },
    );
  }

  Widget _getByBitActivesItem({required BuildContext context}) {
    return const SelectableItem(
      title: 'Активы ByBit',
      icon: Icon(
        Icons.description,
        color: AppColors.secondColor,
      ),
    );
  }

  Widget _getKuCoinActivesItem({required BuildContext context}) {
    return const SelectableItem(
      title: 'Активы KuCoin',
      icon: Icon(
        Icons.description,
        color: AppColors.secondColor,
      ),
    );
  }



}