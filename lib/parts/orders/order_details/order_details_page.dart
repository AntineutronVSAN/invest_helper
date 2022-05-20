
import 'package:flutter/material.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_stateless.dart';
import 'package:invests_helper/data/models/response/google_sheets/google_sheet_order.dart';
import 'package:invests_helper/parts/orders/order_details/order_details_bloc.dart';
import 'package:invests_helper/parts/orders/order_details/order_details_event.dart';
import 'package:invests_helper/parts/orders/order_details/order_details_state.dart';
import 'package:invests_helper/parts/orders/orders_state.dart';
import 'package:invests_helper/theme/header_text_widget.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/app_bar/app_bar.dart';
import 'package:invests_helper/ui_package/app_button/app_button.dart';
import 'package:invests_helper/ui_package/app_info_section/app_info_section.dart';
import 'package:invests_helper/ui_package/refresh_indicator/refresh_indicator.dart';

class OrderDetailsPage extends InvestHelperStatelessWidget<
    OrderDetailsBloc,
    OrderDetailsEvent,
    OrderDetailsState
> {

  final GoogleSheetOrder order;
  final double currentCurse;
  final List<SellPieceInfo> sellPieceInfo;

  const OrderDetailsPage({
    Key? key,
    required OrderDetailsBloc bloc,
    required this.order,
    required this.currentCurse,
    required this.sellPieceInfo,
  }) : super(bloc: bloc, key: key);

  @override
  void onListen(OrderDetailsState newState, BuildContext context) {
    // TODO: implement onListen
  }

  @override
  Widget onStateLoaded(OrderDetailsState newState, BuildContext context) {
    return AppRefreshIndicator(
      onRefresh: () async {
        bloc.refreshEvent();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: iHAppBar(
              title: 'Ордер №${order.orderNumber}',
            onBackTap: () {
                Navigator.of(context).pop();
            }
          ),
          backgroundColor: AppColors.primaryColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  ..._getMainOrderInformation(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getMainOrderInformation() {
    return [
      const IHHeaderTextWidget(text: 'Данные ордера', fontSize: 24.0,),
      AppInfoSection(title: 'Создан', info: order.dateTime,),
      AppInfoSection(title: 'Пара', info: order.pair,
        infoColor: AppColors.amberColor,
        titleColor: AppColors.amberColor,
      ),
      AppInfoSection(title: 'Куплено', info: order.buyedValue.toStringAsFixed(5),
        infoColor: AppColors.amberColor,
        titleColor: AppColors.amberColor,
      ),
      AppInfoSection(title: 'По курсу', info: order.buyedCource.toStringAsFixed(5),),
      AppInfoSection(title: 'В USDT', info: order.usdEq.toStringAsFixed(1),
        infoColor: AppColors.amberColor,
        titleColor: AppColors.amberColor,
      ),
      AppInfoSection(title: 'Где', info: order.whereCrypto,),
      AppInfoSection(title: 'Состояние', info: order.orderState,),
      AppInfoSection(title: 'Коммент', info: order.comment,),
      AppInfoSection(title: 'Комиссии', info: order.comission,),
      const IHHeaderTextWidget(text: 'Данные продаж', fontSize: 24.0,),
      _getSellData(),
    ];
  }



  Widget _getSellData() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: order.orderSellData.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final currentSellData = order.orderSellData[index];
        final selled = currentSellData.hasSellDate?.toString().isNotEmpty ?? false;
        final currentSellCalculatedData = sellPieceInfo[index];
        return Column(
          children: [
            IHHeaderTextWidget(text: 'Продажа $index', fontSize: 20.0,),
            AppInfoSection(title: 'Доход', info: currentSellData.minIncomePercent.toString() + '%',),
            AppInfoSection(title: 'Продать часть', info: currentSellData.minPiceSellPercent.toString() + '%',),
            AppInfoSection(title: 'Продать при курсе', info: currentSellData.planedSellCource.toStringAsFixed(5)),
            AppInfoSection(title: 'Сколько продать', info: currentSellData.planedSellValue.toStringAsFixed(5)),
            AppInfoSection(title: 'Продано?', info: selled ? 'Да' : 'Нет'),
            AppInfoSection(title: 'Дата продажи', info: currentSellData.hasSellDate.toString()),
            AppInfoSection(title: 'Курс продажи', info: currentSellData.hasSellCourse.toString()),

            AppInfoSection(title: 'Значение части в USDT',
              info: currentSellCalculatedData.pieceUsdValue.toStringAsFixed(1),
              infoColor: AppColors.secondTextColor,
              titleColor: AppColors.secondTextColor,
            ),
            AppInfoSection(title: 'До продажи %',
              info: currentSellCalculatedData.deltaPercent.toStringAsFixed(1) + '%',
              infoColor: AppColors.secondTextColor,
              titleColor: AppColors.secondTextColor,
            ),
            AppInfoSection(title: 'Текущий доход %',
              info: currentSellCalculatedData.currentPercent.toStringAsFixed(1) + '%',
              infoColor: AppColors.secondTextColor,
              titleColor: AppColors.secondTextColor,
            ),
            AppInfoSection(title: 'Получить USDT сейчас',
              info: currentSellCalculatedData.currentProfitUsd.toStringAsFixed(1),
              infoColor: AppColors.secondTextColor,
              titleColor: AppColors.secondTextColor,
            ),
            IHButton(
              text: 'Продать',
              onPressed: () {},
              minimumSize: const Size(200.0, 44.0),
            ),
          ],
        );
      }
    );
  }

}