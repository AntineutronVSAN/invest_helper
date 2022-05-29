import 'package:flutter/material.dart';
import 'package:invests_helper/base/bloc_base.dart';
import 'package:invests_helper/base/bloc_state_base.dart';
import 'package:invests_helper/base/stateful_base.dart';
import 'package:invests_helper/theme/error_screen.dart';
import 'package:invests_helper/ui_package/app_error_page/error_page.dart';
import 'package:invests_helper/ui_package/loading_widget/loading_widget.dart';

abstract class InvestHelperStatefulWidget<
    T extends StateFullWidgetWithBloc<B>,
    B extends AdvancedBlocBase<E, GlobalState<S>, S>,
    E,
    S> extends StatefulWidgetStateWithBloc<T, B, E, S> {
  @override
  Widget onLoading() {
    return AppLoadingsWidget.getSimpleLoadingWidget();
  }

  @override
  Widget onError({required BuildContext context, String? error}) {
    return IHErrorPage(
      error: error,
      onReload: () {
        bloc.refreshEvent();
      },
    );
  }

  @override
  void onResult({required BuildContext context, required result}) {
    Navigator.of(context).maybePop(result);
  }

  @override
  void onTokenExpired(BuildContext context) {

  }
}
