import 'package:flutter/material.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/app_button/app_button.dart';
import 'package:invests_helper/ui_package/loading_widget/loading_widget.dart';


class IHSimpleDialog extends StatefulWidget {

  final String title;
  final Widget? body;
  final List<IHSimpleDialogAction> actions;
  final bool loading;

  const IHSimpleDialog({
    Key? key,
    required this.title,
    this.body,
    required this.actions,
    this.loading=false,

  }) : super(key: key);

  @override
  State<IHSimpleDialog> createState() => _IHSimpleDialogState();
}

class _IHSimpleDialogState extends State<IHSimpleDialog> {

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Center(
      child: SizedBox(
        height: height * 0.7,
        child: Dialog(
          elevation: 0,
          backgroundColor: AppColors.secondColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(14))),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _getHeader(context: context),
                _getBodyWidget(context: context),
                if (widget.loading)
                  AppLoadingsWidget.getWidgetLoadingWidget()
                else
                  _getActionsWidget(context: context),
                const SizedBox(height: 5.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getActionsWidget({required BuildContext context}) {
    final size = MediaQuery.of(context).size;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.actions.length,
      itemBuilder: (context, index) {
        return IHButton(
          outsidePadding: const EdgeInsets.all(1.0),
          minimumSize: Size(size.width * 0.6, 35),
          text: widget.actions[index].title,
          onPressed: () {
            widget.actions[index].onTap?.call();
          },
        );
      }
    );
  }

  Widget _getBodyWidget({required BuildContext context}) {
    if (widget.body == null) return const SizedBox.shrink();
    return widget.body!;
  }

  Widget _getHeader({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 35.0,
              color: AppColors.primaryTextColor,)),
          Flexible(child: AppTexts.subtitleText(text: widget.title))
        ],
      ),
    );
  }
}

class IHSimpleDialogAction {
  final String title;
  final Function()? onTap;

  IHSimpleDialogAction({required this.title, required this.onTap});
}