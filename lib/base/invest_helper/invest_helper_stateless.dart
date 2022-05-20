import 'package:flutter/material.dart';
import 'package:invests_helper/base/bloc_base.dart';
import 'package:invests_helper/base/bloc_state_base.dart';
import 'package:invests_helper/base/stateless_base.dart';
import 'package:invests_helper/theme/error_screen.dart';
import 'package:invests_helper/ui_package/loading_widget/loading_widget.dart';


abstract class InvestHelperStatelessWidget<
    B extends AdvancedBlocBase<E, GlobalState<S>, S>,
    E,
    S> extends StatelessWidgetWithBloc<B, E, S> {
  const InvestHelperStatelessWidget({Key? key, required B bloc})
      : super(bloc: bloc, key: key);

  @override
  Widget onLoading() {
    return AppLoadingsWidget.getSimpleLoadingWidget();
  }

  @override
  Widget onError() {
    return AppErrorsWidget.getSimpleErrorWidget();
  }

  @override
  void onTokenExpired(BuildContext context) {
    print('Token expired');
  }

  @override
  void onResult({required BuildContext context, required result}) {
    Navigator.of(context).maybePop(result);
  }
}
