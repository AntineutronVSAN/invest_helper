import 'package:flutter/material.dart';
import 'package:invests_helper/data/models/response/google_sheets/diet.dart';
import 'package:invests_helper/parts/diet/diet_journal/diet_journal_bloc.dart';
import 'package:invests_helper/parts/diet/diet_journal/diet_journal_event.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/app_bar/app_bar.dart';
import 'package:invests_helper/ui_package/app_form/app_form_page.dart';
import 'package:invests_helper/utils/time_service.dart';

class CreateDietEntryPage extends StatefulWidget {
  final List<DietUserModel> users;
  final List<DietProductModel> products;
  final DietJournalBloc dietJournalBloc;

  const CreateDietEntryPage({
    Key? key,
    required this.users,
    required this.products,
    required this.dietJournalBloc,
  }) : super(key: key);

  @override
  State<CreateDietEntryPage> createState() => _CreateDietEntryPageState();
}

class _CreateDietEntryPageState extends State<CreateDietEntryPage> {
  int selectedProductIndex = 0;

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
                  final selectedUserIndex =
                      data[createDietEntryUserSelectionJsonKey] as int;
                  final selectedProductIndex =
                      data[createDietEntryProductSelectionJsonKey] as int;

                  final newJournalData = DietJournalModel(
                    id: -1,
                    dateTime: IHTimeService.getNowFormattedWithTime(),
                    userId: widget.users[selectedUserIndex].id,
                    productId: widget.products[selectedProductIndex].id,
                    weight:
                        double.parse(data[createDietEntryProductWeightJsonKey]),
                  );
                  widget.dietJournalBloc
                      .add(DietJournalAddNewEntryEvent(entry: newJournalData));
                  await widget.dietJournalBloc.stream.first;
                  await widget.dietJournalBloc.stream.first;
                  return true;
                },
                items: [
                  AppFromPageItem(
                    jsonKey: createDietEntryUserSelectionJsonKey,
                    title: 'Выберите пользователя',
                    type: AppFromType.itemsSelection,
                    titleShort: 'Юзер',
                    isRequired: true,
                    itemsSelectionOptions:
                        widget.users.map((e) => e.name).toList(),
                  ),
                  AppFromPageItem(
                      jsonKey: createDietEntryProductSelectionJsonKey,
                      title: 'Выберите продукт',
                      type: AppFromType.itemsSelection,
                      titleShort: 'Продукт',
                      isRequired: true,
                      itemsSelectionOptions:
                          widget.products.map((e) => e.name).toList(),
                      itemsSelectionOnItemSelected: (val) {
                        final selectedVal = val as int;
                        setState(() {
                          selectedProductIndex = selectedVal;
                        });
                      }),
                  AppFromPageItem(
                      jsonKey: createDietEntryProductWeightJsonKey,
                      title: 'Введите вес продукта в граммах',
                      type: AppFromType.floatFromWithOptions,
                      titleShort: 'Вес гр.',
                      isRequired: true,
                      floatFromMaxLength: 5,
                      validators: _getWeightSelectionValidators(),
                      floatFromWithOptionsOptions: _selectProductOptionsList,
                      floatFromWithOptionsHandlers:
                          _getSelectProductOptionsHandles(),
                      floatFromWithOptionsValue: widget
                          .products[selectedProductIndex].oneProductWeight,
                      floatFromWithOptionsOnOptionSelected: (val) {}),
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

  List<double Function(double)> _getSelectProductOptionsHandles() {
    return [
      (val) => val,
      (val) => val * 2.0,
      (val) => val * 3.0,
      (val) => val * 0.5,
      (val) => val * 0.1,
    ];
  }
}

const String createDietEntryUserSelectionJsonKey =
    'createDietEntryUserSelectionJsonKey';
const String createDietEntryProductSelectionJsonKey =
    'createDietEntryProductSelectionJsonKey';
const String createDietEntryProductWeightJsonKey =
    'createDietEntryProductWeightJsonKey';

const List<String> _selectProductOptionsList = [
  'штука',
  '2 штуки',
  '3 штуки',
  '50% от штуки',
  '10% от штуки',
];
