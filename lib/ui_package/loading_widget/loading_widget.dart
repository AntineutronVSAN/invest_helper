

import 'package:flutter/material.dart';
import 'package:invests_helper/theme/ui_colors.dart';

class AppLoadingsWidget {

  static Widget getWidgetLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(
        backgroundColor: AppColors.secondColor2,
        color: AppColors.secondTextColor,
      ),
    );
  }

  static Widget getSimpleLoadingWidget() {
    return Container(
      color: AppColors.primaryColor,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.secondColor,
        ),
      ),
    );
  }

}