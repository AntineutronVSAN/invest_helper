

import 'package:flutter/material.dart';
import 'package:invests_helper/theme/ui_colors.dart';

class AppRefreshIndicator extends StatelessWidget {

  final Widget child;
  final Future<void> Function() onRefresh;
  final double displacement;
  final double edgeOffset;


  const AppRefreshIndicator({
    Key? key,
    required this.onRefresh,
    required this.child,
    this.displacement = 40.0,
    this.edgeOffset = 0.0,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: displacement,
      edgeOffset: edgeOffset,
      child: child,
      onRefresh: onRefresh,
      backgroundColor: AppColors.secondColor2,
      color: AppColors.secondTextColor,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
    );
  }



}