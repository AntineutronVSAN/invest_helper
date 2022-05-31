import 'package:flutter/material.dart';
import 'package:invests_helper/data/models/response/google_sheets/diet.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/app_bar/app_bar.dart';
import 'package:invests_helper/ui_package/app_info_section/app_info_section.dart';
import 'package:invests_helper/ui_package/clicable_card/clicable_card.dart';

class DietProductDetailsPage extends StatelessWidget {
  final DietProductModel productModel;

  const DietProductDetailsPage({
    Key? key,
    required this.productModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: iHAppBar(
            title: productModel.name,
            onBackTap: () {
              Navigator.of(context).pop();
            }),
        backgroundColor: AppColors.primaryColor,
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ..._getProductUnitSection(),
                ..._getDescriptionSection(),
                ..._getParamsSection(),
                ..._getCompositionSection(),
                const SizedBox(height: 50.0,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getProductUnitSection() {
    final pricePerUnit = productModel.oneProductWeight / 100.0 * productModel.price;
    final kKalPerUnit = productModel.oneProductWeight / 100.0 * productModel.kkal;
    final kmPerUnit = kKalPerUnit / kKalPerKm;
    return [
      AppTexts.primaryTitleText(text: 'Единица продукта'),
      IHCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                child:
                AppTexts.primaryCardText(text: productModel.oneProductWeightDescription)),
          ],
        ),
      ),
      AppInfoSection(
        title: 'Вес, гр.',
        info: productModel.oneProductWeight.toStringAsFixed(0),
      ),
      AppInfoSection(
        title: 'Цена',
        info: pricePerUnit.toStringAsFixed(0),
      ),
      AppInfoSection(
        title: 'Калорий',
        info: kKalPerUnit.toStringAsFixed(0),
      ),
      AppInfoSection(
        title: 'Км на велотренажёре',
        info: kmPerUnit.toStringAsFixed(2),
      ),
    ];
  }

  List<Widget> _getParamsSection() {
    return [
      AppTexts.primaryTitleText(text: 'Параметры на 100 грамм'),
      AppInfoSection(
        title: 'Калорийность',
        info: productModel.kkal.toStringAsFixed(0),
      ),
      AppInfoSection(
        title: 'Белки',
        info: productModel.squirrels.toStringAsFixed(0),
      ),
      AppInfoSection(
        title: 'Жиры',
        info: productModel.fats.toStringAsFixed(0),
      ),
      AppInfoSection(
        title: 'Углеводы',
        info: productModel.carbohydrates.toStringAsFixed(0),
      ),
      AppInfoSection(
        title: 'Цена',
        info: productModel.price.toStringAsFixed(0),
      ),
    ];
  }

  List<Widget> _getDescriptionSection() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppTexts.primaryTitleText(text: 'Описание продукта'),
        ],
      ),
      IHCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                child:
                    AppTexts.primaryCardText(text: productModel.description)),
          ],
        ),
      ),
    ];
  }

  List<Widget> _getCompositionSection() {
    if (productModel.composition.isEmpty) return [const SizedBox.shrink()];
    return [
      AppTexts.primaryTitleText(text: 'Состав продукта TODO'),
      AppTexts.primaryTitleText(text: productModel.composition),
    ];
  }
}


/// TODO Это присылать с бэка
/// Сколько в среднем ккал на 1 км на велотренажёре
const int kKalPerKm = 30;