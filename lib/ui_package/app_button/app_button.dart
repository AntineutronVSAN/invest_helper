import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/loading_widget/loading_widget.dart';

class IHButton extends StatelessWidget {
  final String text;
  final double? minWidth;
  final Function()? onPressed;
  final bool loading;
  final double loadingSize;
  final EdgeInsets outsidePadding;
  final EdgeInsets insidePadding;
  final Size? minimumSize;
  final Size? maximumSize;
  final double? width;

  const IHButton({
    Key? key,
    required this.text,
    this.minWidth,
    this.onPressed,
    this.loading = false,
    this.loadingSize = 15.0,
    this.outsidePadding = const EdgeInsets.all(18.0),
    this.insidePadding = const EdgeInsets.symmetric(horizontal: 5.0),
    this.minimumSize,
    this.maximumSize,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      primary: AppColors.primaryColor,
      minimumSize: minimumSize ?? Size(MediaQuery.of(context).size.width * 0.5, 45.0),
      //maximumSize: maximumSize,
      padding: insidePadding,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      backgroundColor: AppColors.greenColor,
    );

    return Center(
      child: Padding(
        padding: outsidePadding,
        child: SizedBox(
          width: maximumSize?.width ?? width,
          child: TextButton(
            style: flatButtonStyle,
            onPressed: loading ? null : onPressed,
            child: loading
                ? SizedBox(
                    child: AppLoadingsWidget.getWidgetLoadingWidget(),
                    width: loadingSize,
                    height: loadingSize,
                  )
                : Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.secondColor),
                  ),
          ),
        ),
      ),
    );
  }
}

class IHCircleButton extends StatelessWidget {

  final Function()? onPressed;
  final Widget icon;

  const IHCircleButton({
    Key? key,
    this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: icon,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(0),
        primary: AppColors.secondTextColor,
        onPrimary: AppColors.primaryColor,
      ),
    );
  }

}