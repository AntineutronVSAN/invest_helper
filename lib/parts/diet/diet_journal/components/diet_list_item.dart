
import 'package:flutter/material.dart';
import 'package:invests_helper/data/models/response/google_sheets/diet.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/ui_package/clicable_card/clicable_card.dart';
import 'package:invests_helper/utils/time_service.dart';

class DietListItem extends StatelessWidget {

  final DietJournalModel entry;
  final DietUserModel user;
  final DietProductModel product;

  const DietListItem({
    Key? key,
    required this.entry,
    required this.user,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IHCard(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Column(
        children: [
          _getCardTitle(),
          _getCardBody(),
        ],
      ),
      onPressed: () {},
    );
  }

  Widget _getCardTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppTexts.primaryCardText(
            text: IHTimeService.onlyTimeFormattedFromStr(dateTime: entry.dateTime),
        ),
        AppTexts.primaryCardText(
            text: entry.weight.toStringAsFixed(0) + " гр.",
        ),
      ],
    );
  }

  Widget _getCardBody() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppTexts.primaryCardText(
          text: user.name,
        ),
        AppTexts.primaryCardText(
          text: product.name,
        ),
      ],
    );
  }
}
