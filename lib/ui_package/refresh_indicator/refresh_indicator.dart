

import 'package:flutter/material.dart';
import 'package:invests_helper/theme/ui_colors.dart';

class AppRefreshIndicator extends StatelessWidget {

  final Widget child;
  final Future<void> Function() onRefresh;

  const AppRefreshIndicator({
    Key? key,
    required this.onRefresh,
    required this.child,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: child,
      onRefresh: onRefresh,
      backgroundColor: AppColors.secondColor2,
      color: AppColors.secondTextColor,
    );
  }



}