import 'package:flutter/material.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_stateless.dart';
import 'package:invests_helper/data/models/app_models/app_crypto_balance.dart';
import 'package:invests_helper/parts/actives/actives_bloc.dart';
import 'package:invests_helper/parts/actives/actives_event.dart';
import 'package:invests_helper/parts/actives/actives_state.dart';
import 'package:invests_helper/parts/actives/components/app_balance_card.dart';
import 'package:invests_helper/ui_package/app_bar/app_bar.dart';
import 'package:invests_helper/ui_package/refresh_indicator/refresh_indicator.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/theme/ui_colors.dart';


class ActivesScreen extends InvestHelperStatelessWidget<
    ActivesBloc,
    ActivesEvent,
    ActivesState
> {
  const ActivesScreen({required ActivesBloc bloc, Key? key})
      : super(bloc: bloc, key: key);

  @override
  void onListen(ActivesState newState, BuildContext context) {
    // TODO: implement onListen
  }

  @override
  Widget onStateLoaded(ActivesState newState, BuildContext context) {
    return _buildBody(newState, context);
  }


  Widget _buildBody(ActivesState newState, BuildContext context) {
    return AppRefreshIndicator(
      onRefresh: () async {
        bloc.add(RefreshPageEvent());
        await bloc.stream.first;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: iHAppBar(title: 'Наши активы'),
          backgroundColor: AppColors.primaryColor,
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  _getUserInfo(newState: newState, context: context),
                  _getBalancesList(
                      balances: newState.balances,
                      context: context
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getUserInfo({
    required ActivesState newState,
    required BuildContext context,
  }) {
    return SizedBox(
      height: 150.0,
      child: Card(
        color: AppColors.secondColor,
        child: ListTile(
          leading: AppTexts.balanceCardDescriptionText(
              text: newState.totalBalance.toStringAsFixed(1) + r' $'),
        ),
      ),
    );
  }

  Widget _getBalancesList({
    required List<AppCryptoBalance> balances,
    required BuildContext context,
  }) {
    return ListView.builder(
      physics: const  NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: balances.length,
        itemBuilder: (context, index) {
          return AppBalanceCard(balance: balances[index]);
        });
  }


}