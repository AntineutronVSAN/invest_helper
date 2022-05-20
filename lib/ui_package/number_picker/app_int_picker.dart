import 'package:flutter/material.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/app_button/app_button.dart';

class IHIntPicker extends StatefulWidget {
  final int currentValue;
  final int minValue;
  final int maxValue;
  final int step;
  final Function(int)? onChanged;
  final MainAxisSize mainAxisSize;

  final List<String>? options;
  final List<int Function(int)>? handlers;

  const IHIntPicker({
    Key? key,
    this.currentValue = 0,
    this.maxValue = 100,
    this.minValue = 0,
    this.step = 5,
    this.onChanged,
    this.mainAxisSize = MainAxisSize.min,
    this.handlers,
    this.options,
  }) : super(key: key);

  @override
  State<IHIntPicker> createState() => _IHIntPickerState();
}

class _IHIntPickerState extends State<IHIntPicker> with SingleTickerProviderStateMixin  {

  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    final hasOptions = widget.options != null
        && widget.handlers != null
        && widget.options?.length == widget.handlers?.length;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: AppColors.secondColor2,
      ),
      child: Column(
        children: [
          if (hasOptions)
            _getOptionsWidget(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: widget.mainAxisSize,
            children: [
              _getTappedWidget(
                  text: '-',
                  onPress: () {
                    final newValue = widget.currentValue - widget.step;
                    if (newValue < widget.minValue) return;
                    widget.onChanged?.call(newValue);
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: AppTexts.digitsText0(
                    text: widget.currentValue.toString(),
                    fontSize: 22,
                    color: AppColors.greenColor),
              ),
              _getTappedWidget(
                  text: '+',
                  onPress: () {
                    final newValue = widget.currentValue + widget.step;
                    if (newValue > widget.maxValue) return;
                    widget.onChanged?.call(newValue);
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getTappedWidget({
    required String text,
    required Function()? onPress,
  }) {
    return GestureDetector(
      onTap: onPress,
      onLongPressStart: (det) {
        if (onPress == null) return;
        controller.addListener(onPress);
        controller.repeat();
      },
      onLongPressEnd: (det) {
        if (onPress == null) return;
        controller.reset();
        controller.removeListener(onPress);
      },
      child: Text(
        text,
        style: const TextStyle(
            color: AppColors.primaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 35.0),
      ));
  }

  Widget _getOptionsWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      height: 50,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.options!.length,
          itemBuilder: (context, index) {
            return IHButton(
              text: widget.options![index],
              outsidePadding: const EdgeInsets.symmetric(horizontal: 5.0),
              insidePadding: const EdgeInsets.all(5.0),
              minimumSize: const Size(45, 25),
              onPressed: () {
                final val = widget.handlers![index](widget.maxValue);
                widget.onChanged?.call(val);
              },
            );
          }),
    );
  }
}
