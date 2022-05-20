

import 'package:flutter/cupertino.dart';
import 'package:invests_helper/theme/ui_colors.dart';

class AppTextStyles {


  static TextStyle getThirdTextStyle({double? fontSize, Color? color}) {
    return TextStyle(
      color: color ?? AppColors.primaryTextColor,
      fontSize: fontSize
    );
  }

  static TextStyle getSubtitleTextStyle() {
    return const TextStyle(
      fontSize: 17.0,
      color: AppColors.primaryTextColor,
    );
  }

  static TextStyle getDigitsTextStyle({
    double fontSize=17.0, Color? color}) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.0
    );
  }
}