import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/ui_package/app_button/app_button.dart';
import 'package:invests_helper/ui_package/dialog/app_dialog.dart';
import 'package:invests_helper/ui_package/form/text_field.dart';
import 'package:invests_helper/ui_package/number_picker/app_int_picker.dart';
import 'package:invests_helper/ui_package/select_item_widget/app_select_widget.dart';


class IHAppForm extends StatefulWidget {
  final List<AppFromPageItem> items;
  final Future<bool> Function(Map<String, dynamic>)? onSubmit;

  final String confirmDialogTitle;
  final String confirmDialogPositive;
  final String confirmDialogNegative;

  const IHAppForm({
    Key? key,
    required this.items,
    this.onSubmit,
    this.confirmDialogTitle = 'Подтвердите создание записи',
    this.confirmDialogPositive = 'Создать',
    this.confirmDialogNegative = 'Ещё раз подумать',
  }) : super(key: key);

  @override
  State<IHAppForm> createState() => _IHAppFormState();
}

class _IHAppFormState extends State<IHAppForm> {
  final resultData = <String, dynamic>{};
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final List<String?> errors = [];

  // AppFromType.floatFrom
  final floatFromFocusNodes = <int, FocusNode>{};
  final floatFromCurrentValues = <int, String>{};

  // AppFromType.intPicker
  final intPickerValues = <int, int>{};

  // AppFromType.itemsSelection
  final itemsSelectionSelectedValues = <int, int>{};

  bool loading = false;

  @override
  void initState() {
    // TODO Данные полей можно хранить в shared pref
    for (var i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];
      _checkItem(item);
      _initJsonData(item);
      _initFocusNodes(item, i);
      _initSelections(item, i);
      errors.add(null);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _getBody(),
        _buildRentButton(context: context),
        const SizedBox(
          height: 150.0,
        ),
      ],
    );
  }

  Widget _getBody() {
    final children = List.generate(widget.items.length, (index) {
      return _buildFormItem(item: widget.items[index], index: index);
    });

    return FormBuilder(
      key: formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildRentButton({
    required BuildContext context,
  }) {
    return IHButton(
      text: 'Создать',
      onPressed: () async {
        final validationResult = _validate();
        if (!validationResult) {
          return;
        }
        await onRentButtonPress(context: context);
      },
      loading: loading,
    );
  }

  Widget _buildFormItem({
    required AppFromPageItem item,
    required int index,
  }) {
    Widget? formWidget;
    switch (item.type) {
      case AppFromType.floatFrom:
        formWidget = _getFloatForm(item: item, index: index);
        break;
      case AppFromType.intPicker:
        formWidget = _getIntPicker(item: item, index: index);
        break;
      case AppFromType.floatPicker:
        throw Exception(
            "floatPicker пока не поддерживается, используйте floatFrom ");
        break;
      case AppFromType.itemsSelection:
        formWidget = _getItemSelection(item: item, index: index);
        break;
    }

    return Column(
      children: [
        AppTexts.primaryTitleText(text: item.title),
        formWidget,
        _getFormErrorSection(item: item, index: index),
      ],
    );
  }

  Widget _getFormErrorSection({
    required AppFromPageItem item,
    required int index,
  }) {
    if (errors[index] != null) {
      return AppTexts.errorText(text: errors[index]!);
    }
    return const SizedBox.shrink();
  }

  Widget _getItemSelection({
    required AppFromPageItem item,
    required int index,
  }) {
    return IHSelectObjectWidget<dynamic>(
      options: item.itemsSelectionOptions!,
      initialValue: itemsSelectionSelectedValues[index] ??
          item.itemsSelectionInitialValue,
      onOptionSelected: (selectedIndex) {
        setState(() {
          itemsSelectionSelectedValues[index] = selectedIndex;
          resultData[item.jsonKey] = selectedIndex;
        });
      },
    );
  }

  Widget _getIntPicker({
    required AppFromPageItem item,
    required int index,
  }) {
    return IHIntPicker(
      mainAxisSize: MainAxisSize.max,
      options: item.intPickerOptions,
      handlers: item.intPickerHandlers,
      minValue: item.intPickerMinValue,
      maxValue: item.intPickerMaxValue,
      step: item.intPickerStep,
      currentValue: intPickerValues[index] ?? item.intPickerMinValue,
      onChanged: (val) {
        setState(() {
          intPickerValues[index] = val;
          resultData[item.jsonKey] = val;
        });
      },
    );
  }

  Widget _getFloatForm({
    required AppFromPageItem item,
    required int index,
  }) {
    return IHTextFromField(
      name: item.jsonKey,
      label: item.titleShort,
      focusNode: floatFromFocusNodes[index]!,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.maxLength(item.floatFromMaxLength,
            errorText: 'Максимум ${item.floatFromMaxLength} символов'),
        FormBuilderValidators.match(r'^[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)$',
            errorText: 'Неверный формат'),
        if (item.isRequired)
          FormBuilderValidators.required(errorText: 'Обязательное поле'),
      ]),
      textInputType: TextInputType.number,
      onChanged: (val) {
        final res = val ?? '0.0';
        floatFromCurrentValues[index] = res;
        resultData[item.jsonKey] = res;
      },
      formKey: formKey,
    );
  }

  void _checkItem(AppFromPageItem item) {
    switch (item.type) {
      case AppFromType.floatFrom:
        _floatFieldItemChecker(item);
        break;
      case AppFromType.intPicker:
        _intPickerItemChecker(item);
        break;
      case AppFromType.floatPicker:
        _floatPickerItemChecker(item);
        break;
      case AppFromType.itemsSelection:
        _itemsSelectionItemChecker(item);
        break;
    }
  }

  void _floatFieldItemChecker(AppFromPageItem item) {
    assert(item.floatFromMaxLength > 0,
        'Для поля типа floatFrom должно быть определено поле maxLength');
  }

  void _intPickerItemChecker(AppFromPageItem item) {}

  void _floatPickerItemChecker(AppFromPageItem item) {}

  void _itemsSelectionItemChecker(AppFromPageItem item) {
    assert(item.itemsSelectionOptions != null,
        'Для itemsSelection должно быть определено поле itemsSelectionOptions');
  }

  void _initJsonData(AppFromPageItem item) {
    resultData[item.jsonKey] = null;
  }

  void _initFocusNodes(AppFromPageItem item, int index) {
    switch (item.type) {
      case AppFromType.floatFrom:
        floatFromFocusNodes[index] = FocusNode();
        break;
      case AppFromType.intPicker:
        break;
      case AppFromType.floatPicker:
        break;
      case AppFromType.itemsSelection:
        break;
    }
  }

  Future<void> onRentButtonPress({
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (newContext) {
          return IHSimpleDialog(
              title: widget.confirmDialogTitle,
              body: _getDialogBody(),
              loading: loading,
              actions: [
                IHSimpleDialogAction(
                  title: widget.confirmDialogPositive,
                  onTap: () async {
                    if (loading) return;
                    Navigator.of(context).pop();
                    setState(() {
                      loading = true;
                    });
                    final res = await widget.onSubmit?.call(resultData);
                    setState(() {
                      loading = false;
                    });
                    if (res ?? true) {
                      Navigator.of(context).pop(true);
                    }

                  },
                ),
                IHSimpleDialogAction(
                  title: widget.confirmDialogNegative,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ]);
        });
  }

  Widget _getDialogBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            final item = widget.items[index];
            return Center(child: AppTexts.secondTitleText(
                text: '${item.titleShort}: ${_getItemHumanDescription(item)}'));
          }),
    );
  }

  String _getItemHumanDescription(AppFromPageItem item) {
    final data = resultData[item.jsonKey];
    switch (item.type) {
      case AppFromType.floatFrom:
        return data;
      case AppFromType.intPicker:
        return data;
      case AppFromType.floatPicker:
        return data;
      case AppFromType.itemsSelection:
        return item.itemsSelectionOptions![data];
    }
  }

  bool _validate() {
    final state = formKey.currentState!;
    final res = state.validate();

    if (!res) return false;

    var result = true;
    for (var i = 0; i < widget.items.length; i++) {
      final currentItem = widget.items[i];
      final value = resultData[currentItem.jsonKey];
      if (currentItem.isRequired && value == null) {
        setState(() {
          errors[i] = 'Обязятельное поле';
        });
        result = false;
      }
      if (!result) return false;

      final validators = currentItem.validators ?? [];
      for (var validator in validators) {
        final err = validator(value);
        if (err != null) {
          result = false;
          setState(() {
            errors[i] = err;
          });
        }
      }
      if (!result) return false;
    }
    if (result) {
      clearErrors();
    }
    return result;
  }

  void clearErrors() {
    setState(() {
      for (var i = 0; i < errors.length; i++) {
        errors[i] = null;
      }
      ;
    });
  }

  void _initSelections(AppFromPageItem item, int i) {
    if (item.type == AppFromType.itemsSelection) {
      resultData[item.jsonKey] = item.itemsSelectionInitialValue;
    }
  }
}

class AppFromPageItem {
  // Общие поля для всех типов
  final String jsonKey;
  final String titleShort;
  final String title;
  final AppFromType type;
  final bool isRequired;
  final List<String? Function(dynamic)>? validators;

  // Поля для floatFrom
  final int floatFromMaxLength;

  // Поля для типа AppFromType.intPicker
  final List<String>? intPickerOptions;
  final List<int Function(int)>? intPickerHandlers;
  final int intPickerMinValue;
  final int intPickerMaxValue;
  final int intPickerStep;

  // Для AppFromType.itemsSelection
  final List<dynamic>? itemsSelectionOptions;
  final int itemsSelectionInitialValue;

  AppFromPageItem({
    required this.jsonKey,
    required this.title,
    required this.type,
    required this.titleShort,
    required this.isRequired,
    this.floatFromMaxLength = -1,
    this.intPickerHandlers,
    this.intPickerOptions,
    this.intPickerMinValue = 0,
    this.intPickerMaxValue = 10000,
    this.intPickerStep = 10,
    this.itemsSelectionOptions,
    this.itemsSelectionInitialValue = 0,
    this.validators,
  });
}

enum AppFromType {
  //textFrom,
  floatFrom,
  //intForm,
  intPicker,
  floatPicker,
  itemsSelection,
}
