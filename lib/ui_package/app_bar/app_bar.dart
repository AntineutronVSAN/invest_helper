

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
          child: Text(title, style: AppTextStyles.getThirdTextStyle(),)
        ),
      ],
    ),
    backgroundColor: AppColors.secondColor,
    shadowColor: AppColors.primaryWithOpacity,
  );

}