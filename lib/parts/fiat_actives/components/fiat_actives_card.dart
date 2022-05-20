import 'package:flutter/material.dart';
import 'package:invests_helper/data/models/response/google_sheets/buys_cash.dart';
import 'package:invests_helper/data/models/response/google_sheets/buys_cash_status.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/utils/human_date_time.dart';
import 'package:invests_helper/utils/icon_by_crypto.dart';

class FiatActivesCard extends StatelessWidget {
  final Map<int, BuysCashStatus> buysStatusesMap;
  final BuysCash buy;

  const FiatActivesCard({
    Key? key,
    required this.buy,
    required this.buysStatusesMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: AppColors.secondColor,
        ),
        child: Row(
          children: [
            _getIconWidget(),
            _getCardBodyWidget(),
          ],
        ),
      ),
    );
  }

  Widget _getCardBodyWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        Column(
          children: [
            AppTexts.balanceCardDescriptionText(text: buy.pair),
            AppTexts.balanceCardDescriptionText(
                text: buy.count.toStringAsFixed(1)),
          ],
        ),
        const SizedBox(
          width: 20.0,
        ),
        AppTexts.dateTimeText(
          fontSize: 14.0,
          text: buy.course.toStringAsFixed(1),
        ),
        const SizedBox(
          width: 20.0,
        ),
        AppTexts.dateTimeText(
          fontSize: 10.0,
          text: HumanDateTime.convertStr(dateTimeStr: buy.dateTime),
        ),

      ]),
    );
  }

  Widget _getIconWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child:
          CryptoIconProvider.getIconByCryptoAsset(asset: buy.pair, size: 25.0),
    );
  }
}
