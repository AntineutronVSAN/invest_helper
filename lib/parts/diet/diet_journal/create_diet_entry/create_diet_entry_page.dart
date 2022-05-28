import 'package:flutter/material.dart';
import 'package:invests_helper/data/models/response/google_sheets/diet.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/app_bar/app_bar.dart';
import 'package:invests_helper/ui_package/app_form/app_form_page.dart';

class CreateDietEntryPage extends StatefulWidget {
  final List<DietUserModel> users;
  final List<DietProductModel> products;

  const CreateDietEntryPage({
    Key? key,
    required this.users,
    required this.products,
  }) : super(key: key);

  @override
  State<CreateDietEntryPage> createState() => _CreateDietEntryPageState();
}

class _CreateDietEntryPageState extends State<CreateDietEntryPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: iHAppBar(
              title: 'Дневник питания',
              onBackTap: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: AppColors.primaryColor,
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: IHAppForm(
                onSubmit: (data) async {
                  print(data);
                },
                items: [
                  AppFromPageItem(
                    jsonKey: 'createDietEntryUserSelectionJsonKey',
                    title: 'Выберите пользователя',
                    type: AppFromType.itemsSelection,
                    titleShort: 'Юзер',
                    isRequired: true,
                    itemsSelectionOptions:
                        widget.users.map((e) => e.name).toList(),
                  ),
                  AppFromPageItem(
                    jsonKey: 'createDietEntryProductSelectionJsonKey',
                    title: 'Выберите продукт',
                    type: AppFromType.itemsSelection,
                    titleShort: 'Продукт',
                    isRequired: true,
                    itemsSelectionOptions:
                        widget.products.map((e) => e.name).toList(),
                  ),
                  AppFromPageItem(
                      jsonKey: 'createDietEntryProductWeightJsonKey',
                      title: 'Введите вес продукта в граммах',
                      type: AppFromType.floatFrom,
                      titleShort: 'Вес гр.',
                      isRequired: true,
                      floatFromMaxLength: 5,
                      validators: _getWeightSelectionValidators()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String? Function(dynamic)> _getWeightSelectionValidators() {
    return [
      (value) {
        try {
          final numVal = double.parse(value);
          if (numVal > 1500) {
            return 'Значение не может быть больше 1500';
          }
        } catch (e) {
          return e.toString();
        }
      }
    ];
  }
}
