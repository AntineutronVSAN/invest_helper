import 'package:flutter/material.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_stateless.dart';
import 'package:invests_helper/parts/fiat_actives/components/fiat_actives_card.dart';
import 'package:invests_helper/parts/fiat_actives/fiat_actives_bloc.dart';
import 'package:invests_helper/parts/fiat_actives/fiat_actives_event.dart';
import 'package:invests_helper/parts/fiat_actives/fiat_actives_state.dart';
import 'package:invests_helper/parts/tab_navigator.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/app_bar/app_bar.dart';
import 'package:invests_helper/ui_package/app_button/app_button.dart';
import 'package:invests_helper/ui_package/clicable_card/clicable_card.dart';
import 'package:invests_helper/ui_package/paginated_list/paginated_list.dart';
import 'package:invests_helper/ui_package/refresh_indicator/refresh_indicator.dart';

class FiatActivePage extends InvestHelperStatelessWidget<FiatActivesBloc,
    FiatActivesEvent, FiatActivesState> {
  const FiatActivePage({required FiatActivesBloc bloc, Key? key})
      : super(bloc: bloc, key: key);

  @override
  void onListen(FiatActivesState newState, BuildContext context) {
    // TODO: implement onListen
  }

  @override
  Widget onStateLoaded(FiatActivesState newState, BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: iHAppBar(title: 'Покупки валют'),
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
                  _getOverviewFiatActives(context: context, state: newState),
                  _getBuysList(context: context, state: newState),
                  const SizedBox(height: 100.0,),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IHButton(
              text: 'Добавить покупку валюты',
              onPressed: () async {
                final res = await Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return TabNavigator.getCreateBuyPage(
                    assets: newState.fiatCurrencies,
                    whereKeep: ['Тинькофф', 'Матрас'],
                    fiatActivesBloc: bloc,
                  );
                }));

                if (res != null && res) {
                  bloc.refreshEvent();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _getOverviewFiatActives({
    required BuildContext context,
    required FiatActivesState state,
  }) {
    return IHCard(
      onPressed: () {},
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: _getStatisticInfoWidget(state: state, context: context),
    );
  }

  Widget _getStatisticInfoWidget({
    required BuildContext context,
    required FiatActivesState state,
  }) {
    final assets = state.info.assets;
    final assetsSum = state.info.assetSum;
    final assetsMean = state.info.meanCurse;
    final width = MediaQuery.of(context).size.width * 0.8;
    return Row(
      children: [
        Expanded(
          child: _getOverviewColumn(
            context: context,
            data: assets,
            width: width,
            columnName: 'Валюта',
          ),
        ),
        Expanded(
          child: _getOverviewColumn(
              context: context,
              width: width,
              columnName: 'Всего',
              data: assetsSum.map((e) => e.toStringAsFixed(1)).toList()),
        ),
        Expanded(
          child: _getOverviewColumn(
              context: context,
              width: width,
              columnName: 'Ср. курс',
              data: assetsMean.map((e) => e.toStringAsFixed(1)).toList()),
        ),
      ],
    );
  }

  Widget _getOverviewColumn({
    required BuildContext context,
    required List<String> data,
    required String columnName,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            final asset = data[index];

            return Column(
              children: [
                if (index == 0)
                  AppTexts.primaryInfoText(
                      text: columnName,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                      padding: const EdgeInsets.symmetric(vertical: 2.0)),
                AppTexts.primaryInfoText(
                    text: asset,
                    padding: const EdgeInsets.symmetric(vertical: 2.0)),
              ],
            );
          }),
    );
  }

  Widget _getBuysList({
    required BuildContext context,
    required FiatActivesState state,
  }) {
    return PaginableList(
      data: state.buys,
      builder: (context, index) {
        return FiatActivesCard(
          buy: state.buys[index],
          buysStatusesMap: state.buysStatusesMap,
        );
      },
    );
  }
}
