

import 'package:flutter/material.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/refresh_indicator/refresh_indicator.dart';

class IHWidgetWithBarCalendar extends StatelessWidget {

  final double appRefreshIndicatorEdgeOffset;
  final double appRefreshIndicatorDisplacement;

  final Future<void> Function()? onRefresh;

  final Widget? appBarBackgroundWidget;
  final Widget? appBarBottomWidget;

  final double expandedHeight;

  final Widget child;

  const IHWidgetWithBarCalendar({
    Key? key,
    this.appRefreshIndicatorDisplacement = 1.0,
    this.appRefreshIndicatorEdgeOffset = 250.0,
    this.onRefresh,
    this.appBarBackgroundWidget,
    this.expandedHeight = 230.0,
    this.appBarBottomWidget,
    required this.child,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: AppRefreshIndicator(
          edgeOffset: appRefreshIndicatorEdgeOffset,
          displacement: appRefreshIndicatorDisplacement,
          onRefresh: () async {
            await onRefresh?.call();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            slivers: [
              // Add the app bar to the CustomScrollView.
              SliverAppBar(
                pinned: true,
                expandedHeight: expandedHeight,
                centerTitle: true,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  centerTitle: true,
                  titlePadding: const EdgeInsetsDirectional.only(
                    start: 0.0,
                    bottom: 0.0,
                  ),
                  background: _getBackground(context: context,),
                  expandedTitleScale: 1.0,
                ),
                backgroundColor: AppColors.primaryColor,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(30.0),
                  child: _getBottomBar(context: context),
                ),
                elevation: 50.0,
                shadowColor: AppColors.secondColor,
                //forceElevated: true,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBottomBar({
    required BuildContext context,
  }) {
    if (appBarBottomWidget == null) return const SizedBox();
    return Stack(
      children: [
        Positioned.fill(
            child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 75.0,
                    decoration: BoxDecoration(
                        color: AppColors.secondColor,
                        borderRadius: BorderRadius.circular(15.0)

                    ),


                  ),
                )
            )
        ),
        appBarBottomWidget!,

      ],
    );
  }

  Widget _getBackground({
    required BuildContext context,
  }) {
    if (appBarBackgroundWidget == null) return const SizedBox.shrink();
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColors.primaryColor,
          ),
        ),
        appBarBackgroundWidget!,
      ],
    );
  }

}
