
import 'package:flutter/material.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/theme/ui_colors.dart';

class SelectableItem extends StatelessWidget {

  final String title;
  final Widget icon;
  final Function()? onTap;

  const SelectableItem({
    Key? key,
    required this.title,
    this.onTap,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextButton(
        onPressed: onTap,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                icon,
                AppTexts.balanceCardDescriptionText(
                  text: title,
                  fontSize: 16.0,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: onTap != null
                      ? AppColors.primaryTextColor
                      : AppColors.primaryColor,
                ),
              ],
            ),
            const Divider(color: AppColors.amberColor,),
          ],
        ),
      ),
    );
  }
}
