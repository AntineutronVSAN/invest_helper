import 'package:flutter/material.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/app_button/app_button.dart';

class IHSelectObjectWidget<T> extends StatelessWidget {
  final List<T> options;
  final Function(int)? onOptionSelected;
  final int initialValue;
  final Widget additionalWidget;

  const IHSelectObjectWidget({
    Key? key,
    required this.options,
    this.onOptionSelected,
    this.initialValue = 0,
    this.additionalWidget = const SizedBox.shrink(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if (options.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: TextButton(
        onPressed: () async {
          await showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return _getDialog(context: context);
              });
        },
        child: Row(
          children: [
            AppTexts.subtitleText(text: options[initialValue].toString()),
            additionalWidget,
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.primaryTextColor,
            )
          ],
        ),
      ),
    );
  }

  Widget _getDialog({required BuildContext context}) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      //backgroundColor: AppColors.secondColor,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        constraints: BoxConstraints(
          maxHeight: size.height * 0.7,
        ),
        width: size.width * 0.8,
        color: AppColors.secondColor,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: options.length,
          itemBuilder: (context, index) {
            return _getDialogItemWidget(
              currentIndex: index,
              selectedIndex: initialValue,
              context: context,
            );
          },
        ),
      ),
    );
  }

  Widget _getDialogItemWidget({
    required int currentIndex,
    required int selectedIndex,
    required BuildContext context,
  }) {
    return TextButton(
      onPressed: () {
        onOptionSelected?.call(currentIndex);
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppTexts.subtitleText(
                      text: options[currentIndex].toString()),
                if (selectedIndex == currentIndex)
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.primaryTextColor,
                  ),
              ],
            ),
            const Divider(
              color: AppColors.primaryTextColor,
              endIndent: 15.0,
            ),
          ],
        ),
      ),
    );
  }
}
