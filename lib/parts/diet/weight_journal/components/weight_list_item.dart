import 'package:flutter/material.dart';
import 'package:invests_helper/data/models/response/google_sheets/diet.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/ui_package/clicable_card/clicable_card.dart';
import 'package:invests_helper/utils/time_service.dart';

class WeightListItem extends StatelessWidget {

  final DietWeightJournalModel entry;
  final DietUserModel user;

  const WeightListItem({
    Key? key,
    required this.entry,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IHCard(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _getCardIcon(),
          _getCardBody(),
          _getWeightSection(),
        ],
      ),
      onPressed: () {},
    );
  }

  Widget _getCardIcon() {
    return AppTexts.primaryIconText(text: user.name);
  }

  Widget _getCardBody() {
    return AppTexts.primaryCardText(
        text: IHTimeService.onlyTimeFormattedFromStr(dateTime: entry.dateTime),
    );
  }

  Widget _getWeightSection() {
    return AppTexts.primaryCardText(
      text: 'Вес - ' + entry.weight.toStringAsFixed(1),
    );
  }

}
