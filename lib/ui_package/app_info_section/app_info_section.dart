

import 'package:flutter/material.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/theme/ui_colors.dart';

class AppInfoSection extends StatelessWidget {

  final String title;
  final String info;
  final Color titleColor;
  final Color infoColor;
  final bool divider;

  const AppInfoSection({
    Key? key,
    required this.title,
    required this.info,
    this.infoColor = AppColors.primaryTextColor,
    this.titleColor = AppColors.primaryTextColor,
    this.divider = true,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTexts.balanceCardDescriptionText(
                  text: title, fontSize: 17.0, color: titleColor),
              AppTexts.balanceCardDescriptionText(
                  text: info, fontSize: 17.0, color: infoColor),
            ],
          ),
          if (divider)
            const Divider(color: AppColors.primaryTextColor,),
        ],
      ),
    );
  }



}