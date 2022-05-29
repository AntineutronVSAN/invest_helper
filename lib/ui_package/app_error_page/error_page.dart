
import 'package:flutter/material.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/app_bar/app_bar.dart';
import 'package:invests_helper/ui_package/app_button/app_button.dart';

class IHErrorPage extends StatelessWidget {

  final String? error;
  final Function()? onReload;

  const IHErrorPage({
    Key? key,
    this.error,
    this.onReload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: iHAppBar(
        title: 'Ошибка',
        onBackTap: () {
          Navigator.of(context).pop();
        }
      ),
      backgroundColor: AppColors.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20.0,),
            AppTexts.primaryTitleText(text: 'Что-то пошло не так :-('),
            const SizedBox(height: 100.0,),
            AppTexts.primaryTitleText(text: error ?? 'Возникла неизвестная ошибка'),
            const SizedBox(height: 100.0,),
            AppTexts.primaryTitleText(text: 'Попробуйте перезагрузить страницу'),
            IHButton(
              text: 'Перезагрузить',
              onPressed: () {
                Navigator.of(context).pop();
                onReload?.call();
              },
            )
          ],
        ),
      ),
    );
  }
}
