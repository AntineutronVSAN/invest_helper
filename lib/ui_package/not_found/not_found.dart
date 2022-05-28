import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/theme/ui_colors.dart';

class IHNotFound extends StatelessWidget {

  const IHNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTexts.primaryTitleText(text: 'Ничего не найдено'),
        const SizedBox(height: 25.0,),
        SizedBox(
          width: 100.0,
          height: 100.0,
          child: SvgPicture.asset(
            'assets/icons/ic_not_found.svg',
            color: AppColors.primaryTextColor,
          ),
        ),
        const SizedBox(height: 100.0,),
      ],
    );
  }
}
