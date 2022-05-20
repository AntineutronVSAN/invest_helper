

import 'package:flutter/material.dart';
import 'package:invests_helper/theme/ui_colors.dart';

class AppSlider extends StatelessWidget {

  final double selectedValue;
  final Function(double)? onChanged;
  final double minValue;
  final double maxValue;

  const AppSlider({
    Key? key,
    required this.selectedValue,
    this.onChanged,
    this.minValue = 0.0,
    this.maxValue = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: selectedValue,
      onChanged: onChanged,
      min: minValue,
      max: maxValue,
      label: '',
      activeColor: AppColors.secondTextColor,
    );
  }


}