

import 'package:flutter/material.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/app_button/app_button.dart';
import 'package:invests_helper/ui_package/slider/app_slider.dart';

class IHSliderWithOptions extends StatelessWidget {

  final List<String> options;
  final List<double Function(double)> handlers;
  final double initialValue;
  final double maxSliderValue;
  final double minSliderValue;
  final Function(double)? onValueChanged;

  final Widget? valueWidget;

  const IHSliderWithOptions({
    Key? key,
    this.initialValue = 0.5,
    this.maxSliderValue = 1.0,
    this.minSliderValue = 0.0,
    this.options = const [],
    this.handlers = const [],
    this.onValueChanged,
    this.valueWidget,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final hasOptions = options.isNotEmpty;
    assert(options.length == handlers.length);
    return Container(
        decoration: BoxDecoration(
          color: AppColors.secondColor2withHalfOpacity,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            if (hasOptions)
              _getMoneyHelpersWidget(),
            _getSliderWidget(),
            _getTextSection(),
          ],
        ));
  }

  Widget _getMoneyHelpersWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      height: 50,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: options.length,
          itemBuilder: (context, index) {
            return IHButton(
              text: options[index],
              outsidePadding: const EdgeInsets.symmetric(horizontal: 5.0),
              insidePadding: const EdgeInsets.all(5.0),
              minimumSize: const Size(45, 25),
              onPressed: () {
                final val = handlers[index](maxSliderValue);
                onValueChanged?.call(val);
              },
            );
          }),
    );
  }


  Widget _getSliderWidget() {
    return Row(
      children: [
        Expanded(
          child: AppSlider(
            selectedValue: initialValue,
            onChanged: onValueChanged,
            minValue: minSliderValue,
            maxValue: maxSliderValue,
          ),
        ),

      ],
    );
  }

  Widget _getTextSection() {
    if (valueWidget == null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppTexts.digitsText0(
                text: initialValue.toStringAsFixed(1)
            ),
          ],
        ),
      );
    }

    return valueWidget!;

  }
}