import 'package:flutter/material.dart';
import 'package:invests_helper/data/models/response/google_sheets/google_sheet_order.dart';
import 'package:invests_helper/parts/orders/orders_state.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/theme/ui_colors.dart';

class OrderCard extends StatelessWidget {
  final GoogleSheetOrder order;
  final String course;
  final List<SellPieceInfo> sellData;

  const OrderCard({
    Key? key,
    required this.order,
    required this.sellData,
    required this.course,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderType = order.orderState.toOrderStateType();
    final cardColor = _getCardColorByState(orderType);

    return Opacity(
      opacity: _getOpacityByState(orderType),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Card(
            color: cardColor,
            shadowColor: AppColors.secondColor,
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppTexts.balanceCardDescriptionText(
                        text: 'Куплено ${order.buyedValue.toStringAsFixed(5)} '
                            '${order.pair.replaceAll('usdt', '').toUpperCase()} '
                            'за ${order.usdEq.toStringAsFixed(2)} ' r'$'),
                    const SizedBox(height: 5.0,),
                  ],
                ),
                subtitle: _getPiecesWidget(),
              ),
            )),
      ),
    );
  }

  double _getOpacityByState(OrderStateType orderType) {
    switch (orderType) {
      case OrderStateType.active:
        return 1.0;
      case OrderStateType.meaned:
        return 0.4;
      case OrderStateType.halfDone:
        return 1.0;
      case OrderStateType.done:
        return 0.9;
      case OrderStateType.unknown:
        return 1.0;
    }
  }

  Color _getCardColorByState(OrderStateType orderType) {
    switch (orderType) {
      case OrderStateType.active:
        return AppColors.secondColor2;
      case OrderStateType.meaned:
        return AppColors.secondColor2;
      case OrderStateType.halfDone:
        return AppColors.secondColor2;
      case OrderStateType.done:
        return AppColors.greenColor;
      case OrderStateType.unknown:
        return AppColors.secondColor2;
    }
  }

  Widget _getPiecesWidget() {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: order.orderSellData.length,
        itemBuilder: (context, index) {
          return _pieceWidget(
            order.orderSellData[index],
            sellData[index],
          );
        });
  }

  Widget _pieceWidget(OrderSellData data, SellPieceInfo sellData) {
    return Card(
      elevation: 5,
      color: data.hasSellCourse == null
          ? AppColors.secondColor
          : AppColors.greenColor,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Wrap(
          spacing: 1.0,
          runSpacing: 10.0,
          alignment: WrapAlignment.center,
          children: [
            AppTexts.balanceCardDescriptionText(
              text: 'Часть: ' + sellData.pieceUsdValue.toStringAsFixed(1)+' USD',
            ),
            const SizedBox(
              width: 15.0,
            ),
            AppTexts.balanceCardDescriptionText(
              text: 'До цели: ' + sellData.deltaPercent.toStringAsFixed(1)+'%',
            ),
            const SizedBox(
              width: 15.0,
            ),
            AppTexts.balanceCardDescriptionText(
              text: 'Профит: ' + sellData.currentPercent.toStringAsFixed(1)+'%',
            ),
          ],
        ),
      ),
    );
  }

  String _getSubtitleText() {
    final date = order.dateTime.split("T")[0];
    return date;
  }

  String _getTitleText() {
    final asset = order.pair;

    return asset.toUpperCase().replaceAll('USDT', '').replaceAll('/', '');
  }
}
