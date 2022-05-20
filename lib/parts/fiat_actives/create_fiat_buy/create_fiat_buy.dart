import 'package:flutter/material.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_form_mixin.dart';
import 'package:invests_helper/data/models/response/google_sheets/buys_cash.dart';
import 'package:invests_helper/parts/fiat_actives/fiat_actives_bloc.dart';
import 'package:invests_helper/parts/fiat_actives/fiat_actives_event.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/app_bar/app_bar.dart';
import 'package:invests_helper/ui_package/app_button/app_button.dart';
import 'package:invests_helper/ui_package/dialog/app_dialog.dart';
import 'package:invests_helper/ui_package/number_picker/app_int_picker.dart';
import 'package:invests_helper/ui_package/number_picker/float_picker.dart';
import 'package:invests_helper/ui_package/refresh_indicator/refresh_indicator.dart';
import 'package:invests_helper/ui_package/select_item_widget/app_select_widget.dart';
import 'package:invests_helper/utils/time_service.dart';

class CreateFiatByPage extends StatefulWidget {
  final List<String> assets;
  final List<String> whereKeep;
  final FiatActivesBloc fiatActivesBloc;

  const CreateFiatByPage({
    Key? key,
    required this.assets,
    required this.whereKeep,
    required this.fiatActivesBloc,
  }) : super(key: key);

  @override
  State<CreateFiatByPage> createState() => _CreateFiatByPageState();
}

class _CreateFiatByPageState extends State<CreateFiatByPage> with IHFormsExtension {
  String? pair;
  double? course = 0.0;
  int? count = 0;
  String? whereKeep;

  int selectedPair = 0;
  int selectedWhereKeep = 0;

  int selectCurseMinVal = 0;
  int selectCurseMaxVal = 50;

  bool loading = false;

  String? errorText;

  @override
  void initState() {
    _updateModelData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _updateModelData();
    return SafeArea(
      child: Scaffold(
        appBar: iHAppBar(
            title: 'Добавить покупку',
            onBackTap: () {
              Navigator.of(context).pop();
            }),
        backgroundColor: AppColors.primaryColor,
        body: AppRefreshIndicator(
          onRefresh: () async {},
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  ..._getSelectPairWidget(),
                  ..._getSelectWhereKeepWidget(),
                  ..._getValueSection(),
                  ..._getSelectCurseSection(),
                  _buildError(error: errorText),
                  _getConfirmButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError({required String? error}) {
    if (error == null) return const SizedBox.shrink();
    return Column(
      children: [
        AppTexts.errorText(text: error),
      ],
    );
  }

  List<Widget> _getSelectPairWidget() {
    return [
      AppTexts.primaryTitleText(text: 'Выберите пару'),
      IHSelectObjectWidget(
        options: widget.assets,
        initialValue: selectedPair,
        onOptionSelected: (index) {
          setState(() {
            selectedPair = index;
          });

        },
      ),
    ];
  }

  List<Widget> _getSelectWhereKeepWidget() {
    return [
      AppTexts.primaryTitleText(text: 'Где будем хранить'),
      IHSelectObjectWidget(
        options: widget.whereKeep,
        initialValue: selectedWhereKeep,
        onOptionSelected: (index) {
          setState(() {
            selectedWhereKeep = index;
          });

        },
      ),
    ];
  }

  List<Widget> _getValueSection() {
    /// odo Это можно из БЛ присылать
    final List<String> options = [
      r'20',
      r'50',
      r'100',
      r'200',
      r'500',
      r'1000',
      r'2000',
    ];
    final List<int Function(int)> handlers = [
          (val) => 20,
          (val) => 50,
          (val) => 100,
          (val) => 200,
          (val) => 500,
          (val) => 1000,
          (val) => 2000,
    ];
    return [
      AppTexts.primaryTitleText(text: 'Сколько купили'),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: IHIntPicker(
          mainAxisSize: MainAxisSize.max,
          options: options,
          handlers: handlers,
          minValue: 0,
          maxValue: 10000,
          step: 10,
          currentValue: count ?? 0,
          onChanged: (val) {
            setState(() {
              count = val;
            });
          },
        ),
      ),
    ];
  }

  List<Widget> _getSelectCurseSection() {
    return [
      AppTexts.primaryTitleText(text: 'По какому курсу'),

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: IHFloatPicker(
          value: course ?? 0.0,
          minSliderValue: selectCurseMinVal.toDouble(),
          maxSliderValue: selectCurseMaxVal.toDouble(),
          minRangeValue: selectCurseMinVal,
          maxRangeValue: selectCurseMaxVal,
          onValueChanged: (value) {
            setState(() {
              course = value;
            });
          },
          onMaxRangeChanged: (value) {
            setState(() {
              if (value > selectCurseMinVal) {
                selectCurseMaxVal = value;
              }
              course = (selectCurseMaxVal + selectCurseMinVal) / 2.0;
            });
          },
          onMinRangeChanged: (value) {
            setState(() {
              if (value < selectCurseMaxVal) {
                selectCurseMinVal = value;
              }
              course = (selectCurseMaxVal + selectCurseMinVal) / 2.0;
            });
          },

        ),
      ),
    ];
  }

  Widget _getConfirmButton() {
    return IHButton(
      text: 'Создать покупку',
      onPressed: () async {
        final res = _validate();
        setState(() {
          errorText = res;
        });
        if (res != null) {
          return;
        }
        await showDialog(
            context: context,
            builder: (newContext) {
              return IHSimpleDialog(
                  title: 'Подтвердите создание ордера',
                  body: _getDialogBody(),
                  loading: loading,
                  actions: [
                    IHSimpleDialogAction(
                      title: 'Создать',
                      onTap: () async {
                        if (loading) return;
                        Navigator.of(context).pop();
                        setState(() {
                          loading = true;
                        });
                        widget.fiatActivesBloc.add(
                            FiatActivesCreateNewBuyEvent(
                                buysCash: BuysCash(
                                    id: -1,
                                    dateTime: IHTimeService.getNowFormatted(),
                                    pair: pair!,
                                    course: course!,
                                    count: count!.toDouble(),
                                    whereKeep: whereKeep!,
                                    status: 1)));
                        await widget.fiatActivesBloc.stream.first;
                        setState(() {
                          loading = false;
                        });
                        Navigator.of(context).pop(true);
                      },
                    ),
                    IHSimpleDialogAction(
                      title: 'Ещё раз подумать',
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ]);
            });

      },
      loading: loading,
    );
  }

  Widget _getDialogBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: AppTexts.primaryTitleText(text: 'Проверьте, пожалуйста, данные asdfasdfasdf'),
        ),
        AppTexts.secondTitleText(text: 'Покупаем: $pair'),
        AppTexts.secondTitleText(text: 'В количестве: $count'),
        AppTexts.secondTitleText(text: 'По курсу: ${course!.toStringAsFixed(1)}'),
        AppTexts.secondTitleText(text: 'Храним: $whereKeep'),
        const SizedBox(height: 25.0,)
      ],
    );
  }

  String? _validate() {

    if (pair == null) return 'Не выбрана валюта';
    if (whereKeep == null) return 'Не выбрано где хранить';
    if (course == null || course! <= 0.0) return 'Не выбран курс';
    if (count == null || count! <= 0) return 'Не выбрано количество';
    return null;

  }

  void _updateModelData() {
    pair = widget.assets[selectedPair];
    whereKeep = widget.whereKeep[selectedWhereKeep];
  }
}
