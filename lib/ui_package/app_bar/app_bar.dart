

import 'package:flutter/material.dart';
import 'package:invests_helper/theme/test_styles.dart';
import 'package:invests_helper/theme/ui_colors.dart';



PreferredSizeWidget iHAppBar({
  required String title,
  Function()? onBackTap,
}) {
  bool canBack = onBackTap != null;
  return AppBar(
    centerTitle: false,
    automaticallyImplyLeading: false,
    titleSpacing: 0,
    title: Stack(

      children: [
        if (canBack)
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: onBackTap,
              child: const SizedBox(
                  width: 50,
                  child: Icon(Icons.arrow_back_ios)),
            ),
          ),
        Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 250.0,
            ),
            child: Row(
              children: [
                Flexible(
                    child: Text(title, style: AppTextStyles.getThirdTextStyle(), maxLines: 1,)),
              ],
            ),
          )
        ),
      ],
    ),
    backgroundColor: AppColors.secondColor,
    shadowColor: AppColors.primaryWithOpacity,
  );

}