
import 'package:flutter/material.dart';
import 'package:invests_helper/ui_package/app_button/app_button.dart';

class AppOptionsWidget<T> extends StatelessWidget {

  final List<String> options;
  final List<T Function(T)> handlers;
  final Function(T) onOptionSelected;
  final T value;

  const AppOptionsWidget({
    Key? key,
    required this.options,
    required this.handlers,
    required this.onOptionSelected,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                final val = handlers[index](value);
                onOptionSelected.call(val);
              },
            );
          }),
    );
  }
}
