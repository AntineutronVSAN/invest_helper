import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:invests_helper/app_strings.dart';
import 'package:invests_helper/data/models/response/google_sheets/diet.dart';
import 'package:invests_helper/parts/diet/weight_journal/weight_journal_bloc.dart';
import 'package:invests_helper/parts/diet/weight_journal/weight_journal_event.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/app_bar/app_bar.dart';
import 'package:invests_helper/ui_package/app_button/app_button.dart';
import 'package:invests_helper/ui_package/dialog/app_dialog.dart';
import 'package:invests_helper/ui_package/form/text_field.dart';
import 'package:invests_helper/ui_package/refresh_indicator/refresh_indicator.dart';
import 'package:invests_helper/ui_package/select_item_widget/app_select_widget.dart';
import 'package:invests_helper/utils/time_service.dart';

class CreateWeightEntryPage extends StatefulWidget {
  final List<DietUserModel> users;
  final WeightJournalBloc weightJournalBloc;
  final GlobalKey<FormBuilderState> formKey;

  const CreateWeightEntryPage({
    Key? key,
    required this.users,
    required this.weightJournalBloc,
    required this.formKey,
  }) : super(key: key);

  @override
  State<CreateWeightEntryPage> createState() => _CreateWeightEntryPageState();
}

class _CreateWeightEntryPageState extends State<CreateWeightEntryPage> {
  final weightFocusNode = FocusNode();
  final GlobalKey<FormBuilderState> weightFormKey = GlobalKey<FormBuilderState>();

  final result = <String, dynamic>{};

  int selectedUser = 0;

  String currentWeight = '';

  String? error;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: iHAppBar(
              title: 'Добавить запись веса',
              onBackTap: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: AppColors.primaryColor,
          body: AppRefreshIndicator(
            onRefresh: () async {},
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ..._getSelectUserSection(context: context),
                    ..._getSelectWeightSection(),
                    _getErrorSection(),
                    _getConfirmButton(context: context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getSelectUserSection({
    required BuildContext context,
  }) {
    return [
      AppTexts.primaryTitleText(text: 'Выберите пользователя'),
      IHSelectObjectWidget(
        options: widget.users.map((e) => e.name).toList(),
        initialValue: selectedUser,
        onOptionSelected: (index) {
          setState(() {
            selectedUser = index;
          });
        },
      ),
    ];
  }

  List<Widget> _getSelectWeightSection() {
    return [
      AppTexts.primaryTitleText(text: 'Введите вес в кг'),
      FormBuilder(
        key: widget.formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IHTextFromField(
            name: 'weight',
            label: 'Вес',
            focusNode: weightFocusNode,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.maxLength(6,
                  errorText: AppStrings.formValidationCommentMaxNSymbols),
              FormBuilderValidators.match(r'^[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)$',
                  errorText: 'Неверный формат'),
              FormBuilderValidators.required(errorText: 'Обязательное поле'),
            ]),
            textInputType: TextInputType.number,
            onChanged: (val) {
              currentWeight = val ?? '0.0';
            },
            formKey: widget.formKey,
          ),
        ),
      ),
    ];
  }

  Widget _getErrorSection() {
    if (error != null) {
      return AppTexts.errorText(text: error!);
    }
    return const SizedBox.shrink();
  }

  Widget _getConfirmButton({required BuildContext context}) {
    return IHButton(
      text: 'Создать',
      loading: loading,
      onPressed: () async {
        FocusScope.of(context).unfocus();
        final res = _validateFields();
        if (!res) return;
        await _showConfirmDialog(context: context);
      },
    );
  }


  Widget _getBodyForDialog() {
    return Column(
      children: [
        AppTexts.primaryInfoText(
            text: 'Юзер - ${widget.users[selectedUser].name}'),
        AppTexts.primaryInfoText(text: 'Вес - $currentWeight'),
      ],
    );
  }

  bool _validateFields() {
    final res = _validate();
    if (res != null) {
      setState(() {
        error = res;
      });
      return false;
    }
    setState(() {
      error = null;
    });
    return true;
  }

  String? _validate() {
    final state = widget.formKey.currentState!;
    final res = state.validate();
    if (!res) {
      return 'Ошибка валидации полей';
    }
    if (double.parse(currentWeight) < 40.0) {
      return 'Вес должен быть больше 40 кг';
    }
    return null;
  }

  Future<void> _showConfirmDialog({required BuildContext context,}) async {
    await showDialog(
        context: context,
        builder: (newContext) {
          return IHSimpleDialog(
              title: 'Подтвердите создание записи веса',
              body: _getBodyForDialog(),
              loading: loading,
              actions: [
                IHSimpleDialogAction(
                  title: 'Создать',
                  onTap: () async {
                    await _onConfirmButtonPress(context: context);
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
  }

  Future<void> _onConfirmButtonPress({required BuildContext context,}) async {
    if (loading) return;
    setState(() {
      loading = true;
    });
    final result = DietWeightJournalModel(
      id: -1,
      dateTime: IHTimeService.getNowFormattedWithTime(),
      userId: widget.users[selectedUser].id,
      weight:
      double.parse(currentWeight.replaceAll(',', '.')),
    );
    Navigator.of(context).pop();
    widget.weightJournalBloc.add(WeightJournalAddEntryEvent(model: result));
    final res = await widget.weightJournalBloc.stream.first;
    Navigator.of(context).pop();
  }
}
