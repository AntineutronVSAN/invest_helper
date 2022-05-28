


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:invests_helper/theme/ui_colors.dart';

class IHTextFromField extends StatefulWidget {
  final GlobalKey<FormBuilderState>? formKey;
  final String name;
  final String label;
  final TextInputType textInputType;
  final FocusNode focusNode;
  final String? initialValue;
  final String? error;
  final String? Function(String?)? validator;
  final void Function(String?)? onSubmitted;
  final void Function(String)? onEditingComplete;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String?)? onChanged;

  const IHTextFromField({
    Key? key,
    this.formKey,
    required this.name,
    required this.label,
    required this.focusNode,
    this.textInputType = TextInputType.text,
    this.validator,
    this.onSubmitted,
    this.onEditingComplete,
    this.initialValue,
    this.error,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.sentences,
    this.inputFormatters,
    this.onChanged,
  }) : super(key: key);

  @override
  _TextFormWidgetState createState() => _TextFormWidgetState();
}

class _TextFormWidgetState extends State<IHTextFromField> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue);
    widget.focusNode.addListener(() {
      if (!widget.focusNode.hasFocus) {
        widget.onEditingComplete?.call(controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      inputFormatters: widget.inputFormatters,
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: Theme.of(context).textTheme.headline4!.copyWith(
          fontSize: 14, color: AppColors.primaryTextColor),
      name: widget.name,
      validator: widget.validator,
      maxLines: 1,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.thirdTextColor),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.greenColor),
        ),

        labelStyle: Theme.of(context)
            .textTheme
            .headline4!
            .copyWith(fontSize: 18, color: AppColors.thirdTextColor),
        // hoverColor: Colors.red,
        labelText: widget.label,
        errorText: widget.error,
        errorMaxLines: 3,

      ),
      cursorColor: AppColors.thirdTextColor,
      keyboardType: widget.textInputType,
      focusNode: widget.focusNode,
      onSubmitted: widget.onSubmitted,
      onChanged: (e) {
        widget.formKey?.currentState?.fields[widget.name]?.validate();
        if (widget.onChanged != null) {
          widget.onChanged!.call(e);
        }
      },

      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

/*

class CardInputFormWidget extends StatefulWidget {

  final Function(NewCardModel)? onSubmit;
  final CardInputsValidationErrors? errors;
  final bool loading;

  CardInputFormWidget({
    this.onSubmit,
    this.errors,
    this.loading = false,
  });

  @override
  State<CardInputFormWidget> createState() => _CardInputFormWidgetState();
}

class _CardInputFormWidgetState extends State<CardInputFormWidget> {
  final cardNumberFocus = FocusNode();
  final ownerNameFocus = FocusNode();
  final cvvCodeFocus = FocusNode();
  final expireDateFocus = FocusNode();

  final GlobalKey<FormBuilderState> formKey = GlobalKey();

  NewCardModel currentCardModel = NewCardModel.empty();

  final TextInputFormatter cardNameInputFormatter = MaskTextInputFormatter(
      mask: '#### #### #### ####', filter: {'#': RegExp(r'[0-9]')});
  final TextInputFormatter cardExpireInputFormatter =
  MaskTextInputFormatter(mask: '##/##', filter: {
    '#': RegExp(r'[0-9]'),
  });
  final TextInputFormatter cardCvvInputFormatter =
  MaskTextInputFormatter(mask: '###', filter: {
    '#': RegExp(r'[0-9]'),
  });


  @override
  void dispose() {
    cardNumberFocus.dispose();
    ownerNameFocus.dispose();
    cvvCodeFocus.dispose();
    expireDateFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            _getCardForm(),
            _getIsMainChecker(),
            _getSaveButton(),
            AmCheckbox(
              value: currentCardModel.isMain,
              onChanged: (val) {
                setState(() {
                  currentCardModel.isMain = val ?? false;
                });
              },
              title: AlfamedStrings.creditCardSetMainField,
            ),
            SizedBox(height: 30.0,),
            AmButtonWidget(
              title: AlfamedStrings.creditCardsSaveCardAction,
              loading: widget.loading,
              callback: () async {
                final validateAll = formKey.currentState!.saveAndValidate();
                if (validateAll) {
                  widget.onSubmit?.call(currentCardModel);
                }
              },
              type: AmButtonType.Primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getCardForm() {
    return FormBuilder(
      onChanged: () {},
      autovalidateMode: AutovalidateMode.disabled,
      key: formKey,
      child: Column(
        children: [
          _getCardNumberField(
            initialValue: currentCardModel.cardNumber,
            error: widget.errors?.numberError,
          ),
          _getExpiredDateWidget(
            initialValue: currentCardModel.expireDate,
            error: widget.errors?.expireError,
          ),
          _getOwnerNameWidget(
            initialValue: currentCardModel.ownerName,
            error: widget.errors?.nameError,
          ),
          _getCvvFieldWidget(
            initialValue: currentCardModel.cvvCode,
            error: widget.errors?.cvvError,
          ),
        ],
      ),
    );
  }

  Widget _getIsMainChecker() {
    return const SizedBox.shrink();
  }

  Widget _getSaveButton() {
    return const SizedBox.shrink();
  }

  Widget _getCvvFieldWidget({
    String? error,
    String? initialValue,
  }) {
    return TextFormWidget(
      formKey: formKey,
      name: AlfamedStrings.creditCardCvvFieldEn,
      label: AlfamedStrings.creditCardCvvFieldRu,
      error: error,
      initialValue: initialValue,
      //validator: FormBuilderValidators.compose(),
      focusNode: cvvCodeFocus,
      onEditingComplete: (text) {},
      inputFormatters: [
        cardCvvInputFormatter
      ],
      textInputType: TextInputType.number,
      onChanged: (e) {
        currentCardModel.cvvCode = e ?? '';
      },
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required<void>(context,
            errorText: AlfamedStrings.alfamedFormIsRequiredField),
        FormBuilderValidators.minLength(context, 3,
            errorText: AlfamedStrings.creditCardCvvFieldError),

      ]),
    );
  }

  Widget _getOwnerNameWidget({
    String? error,
    String? initialValue,
  }) {
    return TextFormWidget(
      formKey: formKey,
      name: AlfamedStrings.creditCardOwnerFieldEn,
      label: AlfamedStrings.creditCardOwnerFieldRu,
      error: error,
      initialValue: initialValue?.toUpperCase(),
      //validator: FormBuilderValidators.compose(),
      focusNode: ownerNameFocus,
      onEditingComplete: (text) {},
      onSubmitted: (e) => focusChange(context, ownerNameFocus, cvvCodeFocus),
      inputFormatters: [],
      textInputType: TextInputType.text,
      onChanged: (e) {
        currentCardModel.ownerName = e?.toUpperCase() ?? '';
      },
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required<void>(context,
            errorText: AlfamedStrings.alfamedFormIsRequiredField),
      ]),
    );
  }

  Widget _getExpiredDateWidget({
    String? error,
    String? initialValue,
  }) {
    return TextFormWidget(
      formKey: formKey,
      name: AlfamedStrings.creditCardExpiredFieldEn,
      label: AlfamedStrings.creditCardExpiredFieldRu,
      error: error,
      initialValue: initialValue,
      //validator: FormBuilderValidators.compose(),
      focusNode: expireDateFocus,
      onEditingComplete: (text) {},
      onSubmitted: (e) => focusChange(context, expireDateFocus, ownerNameFocus),
      inputFormatters: [cardExpireInputFormatter],
      textInputType: TextInputType.number,
      onChanged: (e) {
        currentCardModel.expireDate = e ?? '';
      },
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required<void>(context,
            errorText: AlfamedStrings.alfamedFormIsRequiredField),
        FormBuilderValidators.minLength(context, 5,
            errorText: AlfamedStrings.creditCardExpireFieldCountError),
        _expireMonthValidator,
        _expireDateValidator,

      ]),
    );
  }

  Widget _getCardNumberField({
    String? error,
    String? initialValue,
  }) {
    return TextFormWidget(
      formKey: formKey,
      name: AlfamedStrings.creditCardNumberFieldEn,
      label: AlfamedStrings.creditCardNumberFieldRu,
      error: error,
      initialValue: initialValue,
      //validator: FormBuilderValidators.compose(),
      focusNode: cardNumberFocus,
      onEditingComplete: (text) {},
      onSubmitted: (e) =>
          focusChange(context, cardNumberFocus, expireDateFocus),
      inputFormatters: [cardNameInputFormatter],
      textInputType: TextInputType.number,
      onChanged: (e) {
        currentCardModel.cardNumber = e ?? '';
      },
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required<void>(context,
            errorText: AlfamedStrings.alfamedFormIsRequiredField),
        FormBuilderValidators.minLength(context, 19,
            errorText: AlfamedStrings.creditCardNumberFieldCountError),

      ]),
    );
  }

  String? _expireMonthValidator(String? val) {
    if (val == null) return null;
    if (val.length < 2) return null;
    final monthNumber = int.parse(val[0] + val[1]);
    if (monthNumber <= 12 && monthNumber > 0) return null;
    return AlfamedStrings.creditCardMonthNumberFieldError;
  }

  String? _expireDateValidator(String? val) {
    if (val == null) return null;
    if (val.length < 4) return null;
    final monthNumber = int.parse(val[0] + val[1]);
    final yearNumber = int.parse(val[3] + val[4]);
    final expireDate = DateTime(yearNumber + 2000, monthNumber);
    final now = DateTime.now();
    if (expireDate.isAfter(now)) return null;
    return AlfamedStrings.creditCardExpireDateFieldError;
  }

  void focusChange(BuildContext context, FocusNode current, FocusNode? next) {
    current.unfocus();
    if (next != null) {
      FocusScope.of(context).requestFocus(next);
    }
  }
}

class CardInputsValidationErrors {
  final String? numberError;
  final String? expireError;
  final String? nameError;
  final String? cvvError;

  CardInputsValidationErrors({
    required this.numberError,
    required this.expireError,
    required this.nameError,
    required this.cvvError,
  });

}

*/