import 'package:flutter/material.dart';
import 'package:invests_helper/theme/ui_colors.dart';

class IHHeaderTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;

  const IHHeaderTextWidget({
    Key? key,
    required this.text,
    this.fontSize = 17.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: AppColors.primaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
