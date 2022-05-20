import 'package:flutter/material.dart';
import 'package:invests_helper/theme/test_styles.dart';
import 'package:invests_helper/theme/ui_colors.dart';

class AppTexts {

  static Widget secondTitleText({
    required String text,
    double? fontSize = 16.0,
    Color color = AppColors.primaryInfoTextColor,
    EdgeInsets? padding,
    FontWeight? fontWeight,
  }) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  static Widget primaryTitleText({
    required String text,
    double? fontSize = 20.0,
    Color color = AppColors.primaryInfoTextColor,
    EdgeInsets? padding,
    FontWeight? fontWeight,
  }) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  static Widget primaryInfoText({
    required String text,
    double? fontSize,
    Color color = AppColors.primaryInfoTextColor,
    EdgeInsets? padding,
    FontWeight? fontWeight,
  }) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  static Widget dateTimeText({
    required String text,
    double? fontSize,
    Color color = AppColors.primaryTextColor,
  }) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
      ),
    );
  }

  static Widget balanceCardDescriptionText({
    required String text,
    double? fontSize,
    Color? color,
  }) {
    return Text(
      text,
      style: AppTextStyles.getThirdTextStyle(fontSize: fontSize, color: color),
    );
  }

  static Widget subtitleText({
    required String text
  }) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppTextStyles.getSubtitleTextStyle(),
    );
  }

  static Widget digitsText0({
    required String text,
    double fontSize = 17.0,
    Color color=AppColors.primaryTextColor,
  }) {
    return Text(
      text,
      style: AppTextStyles.getDigitsTextStyle(
        fontSize: fontSize,
        color: color,
      ),
    );
  }

  static Widget errorText({
    required String text,
    double fontSize = 14.0,
    Color color=AppColors.redColor,
  }) {
    return Text(
      text,
      style: AppTextStyles.getDigitsTextStyle(
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}

class AppColoredPriceText extends StatefulWidget {
  final bool isUp;
  final String text;

  const AppColoredPriceText({
    Key? key,
    required this.isUp,
    required this.text,
  }) : super(key: key);

  @override
  State<AppColoredPriceText> createState() => _AppColoredPriceTextState();
}

class _AppColoredPriceTextState extends State<AppColoredPriceText>
    with TickerProviderStateMixin {

  late AnimationController _animationControllerUp;
  late AnimationController _animationControllerDown;
  late Animation _colorTweenUp;
  late Animation _colorTweenDown;

  @override
  void initState() {
    _animationControllerUp = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _animationControllerDown = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

    _colorTweenUp = ColorTween(
        begin: AppColors.greenColor,
        end: AppColors.primaryTextColor).animate(_animationControllerUp);

    _colorTweenDown = ColorTween(
        begin: AppColors.redColor,
        end: AppColors.primaryTextColor).animate(_animationControllerDown);

    _animationControllerUp.forward();
    _animationControllerDown.forward();
    super.initState();
  }


  @override
  void didUpdateWidget(covariant AppColoredPriceText oldWidget) {

    if (widget.isUp) {
      _handleUpAnimation();
    } else {
      _handleDownAnimation();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {

    final currentColorTween = widget.isUp ? _colorTweenUp : _colorTweenDown;


    return AnimatedBuilder(
      animation: currentColorTween,
      builder: (context, child) {
        return Text(widget.text,
          style: TextStyle(color: currentColorTween.value),);
      },
    );
  }

  void _handleDownAnimation() {
    switch(_animationControllerDown.status) {
      case AnimationStatus.dismissed:
        break;
      case AnimationStatus.forward:
        return;
      case AnimationStatus.reverse:
        return;
      case AnimationStatus.completed:
        _animationControllerDown.reset();
        break;
    }
    _animationControllerDown.forward();
    _animationControllerUp.reset();

  }

  void _handleUpAnimation() {
    switch(_animationControllerUp.status) {
      case AnimationStatus.dismissed:
        break;
      case AnimationStatus.forward:
        return;
      case AnimationStatus.reverse:
        return;
      case AnimationStatus.completed:
        _animationControllerUp.reset();
    }
    _animationControllerUp.forward();
    _animationControllerDown.reset();
  }

  @override
  void dispose() {
    super.dispose();
    _animationControllerUp.dispose();
    _animationControllerDown.dispose();
  }
}
