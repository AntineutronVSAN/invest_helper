
import 'package:flutter/material.dart';
import 'package:invests_helper/data/models/response/google_sheets/diet.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/clicable_card/clicable_card.dart';

class DietProductCard extends StatelessWidget {

  final DietProductModel product;

  const DietProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IHCard(
      onPressed: () {
        print('asdfasdf');
      },
        child: _getBody(),
    );
  }

  Widget _getBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTexts.primaryCardText(text: product.name, fontSize: 15.0),
        const Divider(color: AppColors.primaryTextColor,),
        AppTexts.primaryCardText(text: product.description, fontSize: 12.0),
        const Divider(color: AppColors.primaryTextColor,),
        AppTexts.primaryCardText(text: 'Единица веса: '
            '${product.oneProductWeightDescription} = '
            '${product.oneProductWeight.toStringAsFixed(0)} грамм', fontSize: 12.0),
      ],
    );
  }
}
