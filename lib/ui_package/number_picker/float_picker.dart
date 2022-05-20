import 'package:flutter/material.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/ui_package/number_picker/app_int_picker.dart';
import 'package:invests_helper/ui_package/slider/slider_with_options.dart';

class IHFloatPicker extends StatelessWidget {

  final double value;
  final double minSliderValue;
  final double maxSliderValue;
  final Function(double)? onValueChanged;

  final int minRangeValue;
  final Function(int)? onMinRangeChanged;
  final int maxRangeValue;
  final Function(int)? onMaxRangeChanged;

  const IHFloatPicker({
    Key? key,
    required this.value,
    required this.minSliderValue,
    required this.maxSliderValue,
    this.onValueChanged,

    required this.minRangeValue,
    required this.maxRangeValue,
    this.onMaxRangeChanged,
    this.onMinRangeChanged,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IHSliderWithOptions(
      initialValue: value,
      minSliderValue: minSliderValue,
      maxSliderValue: maxSliderValue,
      options: const [],
      handlers: const [],
      onValueChanged: onValueChanged,
      valueWidget: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IHIntPicker(
                  mainAxisSize: MainAxisSize.max,
                  minValue: 0,
                  maxValue: 10000,
                  step: 1,
                  currentValue: minRangeValue,
                  onChanged: onMinRangeChanged,
                ),
                IHIntPicker(
                  mainAxisSize: MainAxisSize.max,
                  minValue: 1,
                  maxValue: 10000,
                  step: 1,
                  currentValue: maxRangeValue,
                  onChanged: onMaxRangeChanged,
                ),

              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: AppTexts.digitsText0(text: 'Текущее значение ${value.toStringAsFixed(2)}'),
            ),
          ],
        ),
      ),
    );
  }
}
