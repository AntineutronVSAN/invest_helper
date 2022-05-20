

import 'package:flutter/material.dart';
import 'package:invests_helper/ui_package/select_item_widget/app_select_widget.dart';

mixin IHFormsExtension {

  Widget getSelectableItemWidget<T>({
    required List<T> options,
    required int initialValue,
    Function(int)? onOptionSelected,
    Widget? additionalWidget,
  }) {
    return IHSelectObjectWidget(
      options: options,
      initialValue: initialValue,
      onOptionSelected: onOptionSelected,
      additionalWidget: additionalWidget ?? const SizedBox.shrink(),
    );
  }

}