import 'package:flutter/material.dart';
import 'package:invests_helper/theme/ui_colors.dart';

class IHCard extends StatelessWidget {
  final BoxDecoration decoration;
  final ButtonStyle? style;
  final VoidCallback? onPressed;
  final Widget child;
  final Clip clipBehavior;
  final double? height;
  final EdgeInsets padding;
  final EdgeInsets contentPadding;
  final double cardBorderRadius;

  const IHCard({
    Key? key,
    required this.child,
    this.style,
    this.onPressed,
    this.clipBehavior = Clip.none,
    this.decoration = const BoxDecoration(),
    this.height,
    this.padding = const EdgeInsets.all(8.0),
    this.contentPadding = const EdgeInsets.all(8.0),
    this.cardBorderRadius = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: height,
        child: ElevatedButton(
            clipBehavior: clipBehavior,

            style: style ??
                TextButton.styleFrom(
                  primary: AppColors.primaryTextColor,
                  backgroundColor: AppColors.secondColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(cardBorderRadius), // <-- Radius
                  ),
                  //padding: padding
                ),
            onPressed: onPressed,
            child: Padding(
              padding: contentPadding,
              child: child,
            )),
      ),
    );
  }
}

class AmRoundedCard extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Clip clipBehavior;
  final Color backgroundColor;
  final double borderWidth;
  final BoxDecoration decoration;

  const AmRoundedCard(
      {Key? key,
      required this.child,
      this.onPressed,
      this.clipBehavior = Clip.none,
      this.backgroundColor = Colors.white,
      this.borderWidth = 1,
      this.decoration = const BoxDecoration()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IHCard(
        clipBehavior: clipBehavior,
        onPressed: onPressed,
        decoration: decoration,
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                width: borderWidth,
                color: AppColors.secondColor2,
              )),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        ),
        child: child);
  }
}
