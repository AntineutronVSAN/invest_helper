


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/app_option_widget/app_options_widget.dart';

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


class IHTextFromFieldWithOptions<T> extends StatefulWidget {
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

  final List<String> options;
  final List<T Function(T)> optionsHandlers;
  final T optionValue;
  final Function(T)? onOptionSelected;

  const IHTextFromFieldWithOptions({
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
    required this.options,
    required this.optionsHandlers,
    required this.optionValue,
    this.onOptionSelected,
  }) : super(key: key);

  @override
  _IHTextFromFieldWithOptionsState<T> createState() => _IHTextFromFieldWithOptionsState<T>();
}

class _IHTextFromFieldWithOptionsState<T> extends State<IHTextFromFieldWithOptions<T>> {
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
    return Column(
      children: [
        AppOptionsWidget<T>(
          options: widget.options,
          handlers: widget.optionsHandlers,
          onOptionSelected: (val) {
            widget.onOptionSelected?.call(val);
            controller.text = val.toString();
          },
          value: widget.optionValue!,
        ),
        FormBuilderTextField(
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
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}