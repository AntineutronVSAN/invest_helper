import 'package:flutter/material.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/ui_package/app_bar/app_bar.dart';
import 'package:invests_helper/ui_package/app_button/app_button.dart';

class AppErrorsWidget {
  static Widget getSimpleErrorWidget() {
    return Scaffold(
      appBar: iHAppBar(
        title: 'Ошибка',
      ),
      body: Column(
        children: [
          AppTexts.primaryTitleText(text: 'Что-то пошло не так'),
          const SizedBox(height: 100.0,),
          AppTexts.primaryTitleText(
              text: 'Оштибка', fontSize: 15.0),
          IHButton(
            text: 'Перезагрузить',
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
