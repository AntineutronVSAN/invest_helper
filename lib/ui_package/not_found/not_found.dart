import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/app_bar/app_bar.dart';

class IHNotFound extends StatelessWidget {

  final bool isPage;
  final String? title;
  final bool isBack;

  const IHNotFound({
    Key? key,
    this.isPage=false,
    this.title,
    this.isBack=false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if (!isPage) {
      return _getBody();
    }

    return Scaffold(
      appBar: iHAppBar(
        title: title ?? 'Ничего не найдено',
        onBackTap: isBack ? () => Navigator.of(context).maybePop() : null
      ),
      backgroundColor: AppColors.primaryColor,
      body: _getBody(),
    );


  }

  Widget _getBody() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppTexts.primaryTitleText(text: 'Ничего не найдено'),
          ],
        ),
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


