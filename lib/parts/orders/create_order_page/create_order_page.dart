import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:invests_helper/app_strings.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_stateful.dart';
import 'package:invests_helper/base/stateful_base.dart';
import 'package:invests_helper/data/models/response/google_sheets/google_sheet_order.dart';
import 'package:invests_helper/parts/orders/create_order_page/create_order_bloc.dart';
import 'package:invests_helper/parts/orders/create_order_page/create_order_event.dart';
import 'package:invests_helper/parts/orders/create_order_page/create_order_state.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/ui_package/app_bar/app_bar.dart';
import 'package:invests_helper/ui_package/app_button/app_button.dart';
import 'package:invests_helper/ui_package/dialog/app_dialog.dart';
import 'package:invests_helper/ui_package/select_item_widget/app_select_widget.dart';
import 'package:invests_helper/theme/header_text_widget.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/ui_package/slider/slider_with_options.dart';
import 'package:invests_helper/ui_package/unfocus_widget/unfocus_widget.dart';
import 'package:invests_helper/ui_package/form/text_field.dart';

import 'components/sell_data_item.dart';

class CreateOrderPage extends StateFullWidgetWithBloc<CreateOrderBloc> {
  /// Если [order] не null - то это редактирование ордера
  final GoogleSheetOrder? order;

  const CreateOrderPage({
    Key? key,
    required CreateOrderBloc bloc,
    this.order,
  }) : super(bloc: bloc, key: key);

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends InvestHelperStatefulWidget<CreateOrderPage,
    CreateOrderBloc, CreateOrderEvent, CreateOrderPageState> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey();
  final commentFocusNode = FocusNode();

  @override
  void onListen(CreateOrderPageState newState, BuildContext context) {
    if (newState.orderCreatedSuccessfully) {
      Navigator.of(context).maybePop(true);
    }
  }

  @override
  Widget onStateLoaded(CreateOrderPageState newState, BuildContext context) {
    return SafeArea(
      child: UnfocusWidget(
        child: Scaffold(
          appBar: iHAppBar(
              title: 'Новый ордер',
              onBackTap: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: AppColors.primaryColor,
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
              child: Column(
                children: [
                  ..._getFieldsList(context: context, state: newState),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getFieldsList({
    required BuildContext context,
    required CreateOrderPageState state,
  }) {
    return [
      const IHHeaderTextWidget(text: 'Данные ордера'),
      ..._selectOrderPlaceSection(state: state, context: context),
      ..._getSelectAssetSection(state: state, context: context),
      _getUsdPriceSection(state: state, context: context),
      _getCommentField(context: context),
      const IHHeaderTextWidget(text: 'Данные продаж'),
      _getSellDataSection(state: state, context: context),
      _getCreateSellButton(state: state, context: context),
      _getConfirmButton(state: state, context: context),
      const SizedBox(
        height: 25.0,
      ),
    ];
  }

  Widget _getConfirmButton({
    required BuildContext context,
    required CreateOrderPageState state,
  }) {
    final hasErrors = state.hasErrors?.isNotEmpty ?? false;
    final hasSells = state.sellsData.isNotEmpty;
    final hasSellsError = state.sellsDataError?.isNotEmpty ?? false;
    if (hasErrors || hasSellsError || !hasSells) {
      return const SizedBox.shrink();
    }
    final height = MediaQuery.of(context).size.width;

    return IHButton(
      text: 'Создать ордер',
      minimumSize: Size(height * 0.5, 44),
      loading: state.createOrderLoading,
      onPressed: () async {
        await showDialog(
            context: context,
            builder: (newContext) {
              return IHSimpleDialog(
                  title: 'Подтвердите создание ордера',
                  body: _getBodyForDialog(state: state),
                  loading: state.createOrderLoading,
                  actions: [
                    IHSimpleDialogAction(
                      title: 'Создать',
                      onTap: () {
                        bloc.add(CreateOrderNewOrderConfirmEvent());
                        Navigator.of(context).pop();
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
    );
  }

  Widget _getBodyForDialog({
    required CreateOrderPageState state,
  }) {

    final buyValue = state.howBySliderData.currentValue;
    final buyValueAsset = state.howBySliderData.usdtAsset;
    final buyCrypto = state.howBySliderData.cryptoValue;
    final buyCryptoAsset = state.howBySliderData.cryptoAsset;
    final where = state.whereCreateOrder[state.selectedWhereCanCreateOrder];
    final sellsCount = state.sellsData.length;

    return Column(
      children: [
        AppTexts.balanceCardDescriptionText(
          text: 'Создание ордера', fontSize: 17.0, color: AppColors.secondTextColor),
        AppTexts.balanceCardDescriptionText(
            text: 'Потратим - $buyValue $buyValueAsset'),
        AppTexts.balanceCardDescriptionText(
            text: 'Купим - $buyCrypto $buyCryptoAsset'),
        AppTexts.balanceCardDescriptionText(
            text: 'Оформими на - $where'),
        AppTexts.balanceCardDescriptionText(
            text: 'Число продаж - $sellsCount'),
        ...List.generate(state.sellsData.length, (index) {
          final currentSell = state.sellsData[index];
          final profitPercent = currentSell.profitPercent;
          final sellPercent = currentSell.sellPercent;
          final profit = currentSell.usdtProfit;
          final profitAsset = currentSell.usdtAsset;
          return Column(
            children: [
              AppTexts.balanceCardDescriptionText(
                  text: 'Продажа $index', fontSize: 17.0, color: AppColors.secondTextColor),
              AppTexts.balanceCardDescriptionText(
                  text: 'Процент профита - $profitPercent'),
              AppTexts.balanceCardDescriptionText(
                  text: 'Процент продажи - $sellPercent'),
              AppTexts.balanceCardDescriptionText(
                  text: 'Сумма продажи - $profit $profitAsset'),
            ],
          );
        }),
      ],
    );
  }

  Widget _getSellDataSection({
    required BuildContext context,
    required CreateOrderPageState state,
  }) {
    final sellsData = state.sellsData;
    return Column(
      children: [
        if (state.sellsDataError?.isNotEmpty ?? false)
          AppTexts.errorText(text: state.sellsDataError!),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sellsData.length,
            itemBuilder: (context, index) {
              final currentSellData = sellsData[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SellDataItem(
                  sellPercentInitialValue: currentSellData.sellPercent,
                  minProfitInitialValue: currentSellData.profitPercent,
                  onDelete: () {
                    bloc.add(CreateOrderSellDeletedEvent(index: index));
                  },
                  onMinProfitChanged: (value) {
                    bloc.add(CreateOrderProfitPercentChangedEvent(
                        index: index, value: value));
                  },
                  onSellPercentChanged: (value) {
                    bloc.add(CreateOrderSellPercentChangedEvent(
                        index: index, value: value));
                  },
                  profitData:
                      '${currentSellData.usdtProfit.toStringAsFixed(1)} '
                      '${currentSellData.usdtAsset}',
                ),
              );
            }),
      ],
    );
  }

  Widget _getUsdPriceSection({
    required BuildContext context,
    required CreateOrderPageState state,
  }) {
    /// odo Это можно из БЛ присылать
    final List<String> options = [
      r'20$',
      r'50$',
      r'100$',
      r'10%',
    ];
    final List<double Function(double)> handlers = [
      (val) => 20,
      (val) => 50,
      (val) => 100,
      (val) => 0.1 * val,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: IHSliderWithOptions(
        initialValue: state.howBySliderData.currentValue,
        minSliderValue: state.howBySliderData.minValue,
        maxSliderValue: state.howBySliderData.maxValue,
        options: options,
        handlers: handlers,
        onValueChanged: (value) {
          bloc.add(HowBuyCryptoChangedEvent(usdt: value));
        },
        valueWidget: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 8.0),
          child: Row(
            children: [
              AppTexts.digitsText0(
                  text: state.howBySliderData.currentValue.toStringAsFixed(1) +
                      ' ${state.howBySliderData.usdtAsset}'),
              const Spacer(),
              AppTexts.digitsText0(
                  text: state.howBySliderData.cryptoValue.toStringAsFixed(5) +
                      ' ${state.howBySliderData.cryptoAsset}'),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getSelectAssetSection({
    required BuildContext context,
    required CreateOrderPageState state,
  }) {
    return [
      IHSelectObjectWidget<String>(
        options: state.assets,
        onOptionSelected: (val) {
          bloc.add(AssetSelectedEvent(selectedIndex: val));
        },
        initialValue: state.selectedAsset,
        additionalWidget: Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: AppTexts.digitsText0(
              text: state.assetsPrices[state.selectedAsset].toString()),
        ),
      ),
      const Divider(
        color: AppColors.primaryTextColor,
      ),
    ];
  }

  List<Widget> _selectOrderPlaceSection({
    required BuildContext context,
    required CreateOrderPageState state,
  }) {
    return [
      IHSelectObjectWidget<String>(
        options: state.whereCreateOrder,
        onOptionSelected: (val) {
          bloc.add(WhereCreateOrderSelectedEvent(selectedIndex: val));
        },
        initialValue: state.selectedWhereCanCreateOrder,
      ),
      const Divider(
        color: AppColors.primaryTextColor,
      ),
    ];
  }

  Widget _getCreateSellButton({
    required BuildContext context,
    required CreateOrderPageState state,
  }) {
    /*if (state.sellsData.length >= 2) {
      return const SizedBox.shrink();
    }*/
    return IHButton(
      text: 'Добавить продажу',
      onPressed: () {
        bloc.add(CreateOrderSellAddedEvent());
      },
    );
  }

  Widget _getCommentField({required BuildContext context}) {
    return IHTextFromField(
      formKey: formKey,
      name: 'comment',
      label: 'Комментарий',
      focusNode: commentFocusNode,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.maxLength(15,
            errorText: AppStrings.formValidationCommentMaxNSymbols),
      ]),
    );
  }

  List<Widget> _getSellsList() {
    return [];
  }
}
