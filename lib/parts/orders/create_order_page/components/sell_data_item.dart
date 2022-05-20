

import 'package:flutter/material.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/number_picker/app_int_picker.dart';

class SellDataItem extends StatelessWidget {

  final Function()? onDelete;

  final Function(int)? onMinProfitChanged;
  final Function(int)? onSellPercentChanged;

  final int minProfitInitialValue;
  final int sellPercentInitialValue;

  final String? profitData;

  const SellDataItem({
    Key? key,
    this.onDelete,
    this.onMinProfitChanged,
    this.onSellPercentChanged,
    required this.minProfitInitialValue,
    required this.sellPercentInitialValue,
    this.profitData,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.secondColor,
          borderRadius: BorderRadius.circular(15.0)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 5.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppTexts.subtitleText(text: 'Минимальный процент профита'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppTexts.subtitleText(text: 'Какую часть продать'),
                      ),

                    ],
                  ),
                ),
                //const Spacer(),
                Flexible(
                  child: Column(
                    children: [
                      IHIntPicker(
                        minValue: 0,
                        maxValue: 3000,
                        step: 5,
                        currentValue: minProfitInitialValue,
                        onChanged: onMinProfitChanged,
                      ),
                      const SizedBox(height: 5.0,),
                      IHIntPicker(
                        minValue: 0,
                        maxValue: 100,
                        step: 5,
                        currentValue: sellPercentInitialValue,
                        onChanged: onSellPercentChanged,
                      ),
                    ],
                  ),
                ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: AppTexts.subtitleText(text: 'Получим - ${profitData ?? ''}'),
                ),
                GestureDetector(
                  child: const Icon(Icons.delete, size: 35, color: AppColors.amberColor,),
                  onTap: onDelete,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }



}