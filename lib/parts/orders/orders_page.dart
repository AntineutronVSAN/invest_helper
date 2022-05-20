import 'package:flutter/material.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_stateful.dart';
import 'package:invests_helper/base/invest_helper/invest_helper_stateless.dart';
import 'package:invests_helper/base/stateful_base.dart';
import 'package:invests_helper/data/models/response/google_sheets/google_sheet_order.dart';
import 'package:invests_helper/parts/orders/components/order_card.dart';
import 'package:invests_helper/parts/orders/orders_bloc.dart';
import 'package:invests_helper/parts/orders/orders_event.dart';
import 'package:invests_helper/parts/orders/orders_state.dart';
import 'package:invests_helper/parts/tab_navigator.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/ui_package/app_bar/app_bar.dart';
import 'package:invests_helper/ui_package/dialog/app_dialog.dart';
import 'package:invests_helper/ui_package/paginated_list/paginated_list.dart';
import 'package:invests_helper/ui_package/refresh_indicator/refresh_indicator.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/utils/icon_by_crypto.dart';

class OrdersScreen extends StateFullWidgetWithBloc<OrdersBloc> {

  OrdersScreen({required OrdersBloc bloc}) : super(bloc: bloc);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends InvestHelperStatefulWidget<
    OrdersScreen,
    OrdersBloc,
    OrdersEvent,
    OrdersState
> {

  List<bool> selectedOrders = [];
  bool isOrderSelection = false;
  int currentOrdersLen = 0;

  @override
  void onListen(OrdersState newState, BuildContext context) {
    // TODO: implement onListen
  }

  void _unselectAllOrders() {
    setState(() {
      isOrderSelection = false;
      for(var i = 0; i<selectedOrders.length; i++) {
        selectedOrders[i] = false;
      }
    });
  }

  @override
  Widget onStateLoaded(OrdersState newState, BuildContext context) {
    if (currentOrdersLen != newState.orders.length) {
      currentOrdersLen = newState.orders.length;
      selectedOrders = List.generate(newState.orders.length, (index) => false);
    }
    return AppRefreshIndicator(
      onRefresh: () async {
        if (isOrderSelection) return;
        bloc.add(RefreshOrdersEvent());
        await bloc.stream.first;
      },
      child: WillPopScope(
        onWillPop: () async {
          if (isOrderSelection) {
            _unselectAllOrders();
            return false;
          }
          return true;
        },
        child: SafeArea(
          child: Scaffold(
            appBar: iHAppBar(title: 'Наши ордера'),
            backgroundColor: AppColors.primaryColor,
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    _getOrdersList(state: newState, context: context),
                  ],
                ),
              ),
            ),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isOrderSelection)
                  _getCreateOrderButton(),
                const SizedBox(width: 5.0,),
                if (isOrderSelection)
                  _getOrdersMeanButton(newState: newState),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getOrdersMeanButton({required OrdersState newState}) {
    return FloatingActionButton(
      heroTag: '2',
      onPressed: () async {
        final res = _validateSelectedOrders(newState: newState);
        if (res != null) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 2),
                content: AppTexts.errorText(text: res),
              )
          );
          return;
        }

        await showDialog(
          context: context,
          builder: (newContext) {
            return IHSimpleDialog(
                title: 'Подтвердите усреднение ордеров',
                body: _getOrdersMeanBody(newState: newState, context: context),
                loading: newState.confirmMeanLoading,
                actions: [
                  IHSimpleDialogAction(
                    title: 'Усреднить',
                    onTap: () {
                      bloc.add(OrdersPageMeanOrderEvent(
                          selectedOrders: selectedOrders));
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

        _unselectAllOrders();
      },
      backgroundColor: AppColors.secondTextColor2,
      child: const Icon(Icons.add_to_photos, color: AppColors.secondColor2,),

    );
  }

  Widget _getOrdersMeanBody({
    required OrdersState newState,
    required BuildContext context,
  }) {

    final List<GoogleSheetOrder> meanedOrders = [];
    assert(newState.orders.length == selectedOrders.length);
    for(var i = 0; i<newState.orders.length; i++) {
      final currentOrderSelected = selectedOrders[i];
      final currentOrder = newState.orders[i];
      if (currentOrderSelected) {
        meanedOrders.add(currentOrder);
      }
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: meanedOrders.length,
      itemBuilder: (context, index) {
        final currentOrder = meanedOrders[index];
        return Column(
          children: [
            AppTexts.digitsText0(
              color: AppColors.greenColor,
              fontSize: 18.0,
              text: 'Ордер №${currentOrder.orderNumber}'
            ),
            AppTexts.subtitleText(
                text: 'Пара ${currentOrder.pair}'
            ),
            AppTexts.subtitleText(
                text: '${currentOrder.buyedValue.toStringAsFixed(5)} '
                    '${currentOrder.pair.replaceAll('usdt', '').toUpperCase()}'
            ),
            AppTexts.subtitleText(
                text: '${currentOrder.usdEq.toStringAsFixed(1)} USDT'
            ),
            const SizedBox(height: 25.0,),
          ],
        );
      });

  }

  Widget _getCreateOrderButton() {
   return FloatingActionButton(
     heroTag: '1',
     onPressed: () async {
       final result = await Navigator.of(context).push(MaterialPageRoute(
           builder: (context) {
             return TabNavigator.getCreateOrderPage();
           }));
       if (result == true) {
         bloc.add(RefreshOrdersEvent());
       }
     },
     backgroundColor: AppColors.secondTextColor2,
     child: const Icon(Icons.description, color: AppColors.secondColor2,),

   );
  }

  String? _validateSelectedOrders({required OrdersState newState}) {

    var selectedOrdersCount = 0;
    var isTheSameAssets = true;

    String? currentAsset;

    int? firstPieceSellCurse;
    int? firstPieceSellPercent;


    for(int i=0; i<selectedOrders.length; i++) {
      final curSelectState = selectedOrders[i];

      if (curSelectState) {
        selectedOrdersCount++;

        currentAsset ??= newState.orders[i].pair;
        firstPieceSellCurse ??= newState.orders[i].orderSellData[0].minIncomePercent;
        firstPieceSellPercent ??= newState.orders[i].orderSellData[0].minPiceSellPercent;

        if (isTheSameAssets) {
          isTheSameAssets = currentAsset == newState.orders[i].pair;
          if (!isTheSameAssets) {
            return 'Усреднять можно только ордера одной пары';
          }
        }

        final isTheSameSellData =
            (firstPieceSellCurse == newState.orders[i].orderSellData[0].minIncomePercent)
                && (firstPieceSellPercent == newState.orders[i].orderSellData[0].minPiceSellPercent);
        if (!isTheSameSellData) {
          return 'У усредняемых ордеров должны быть одинаковые данные продаж';
        }
      }
    }
    if (selectedOrdersCount < 2) {
      return 'Для усреднения нужно выбрать как мини'
        'мум 2 ордера';
    }
    return null;
  }

  Widget _getOrdersList({
    required OrdersState state,
    required BuildContext context,
  }) {

    return PaginableList(
      data: state.orders,
      builder: (BuildContext context, int index) {
        return InkWell(
          onLongPress: () {
            if (!isOrderSelection) {
              setState(() {
                _selectOrder(index: index);
              });
            }
          },
          onTap: () async {
            if (!isOrderSelection) {
              final result = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return TabNavigator.getOrderDetailsPage(
                      order: state.orders[index],
                      currentCurse: double.parse(state.currentPrices[index]),
                      sellPieceInfo: state.sellData[index],
                    );
                  }));
              return;
            }
            setState(() {
              _selectOrder(index: index);
            });
          },
          child: Stack(
            children: [

              OrderCard(
                order: state.orders[index],
                sellData: state.sellData[index],
                course: state.currentPrices[index],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CryptoIconProvider.getIconByCryptoAsset(size: 37,
                    asset: state.orders[index].pair),
              ),
              if (isOrderSelection)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Checkbox(
                      activeColor: AppColors.secondTextColor,
                      value: selectedOrders[index],
                      onChanged: (_) {}
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _selectOrder({required int index}) {
    selectedOrders[index] = !selectedOrders[index];
    var hasSelected = false;

    for(var i in selectedOrders) {
      if (i) {
        hasSelected = true;
        break;
      }
    }
    isOrderSelection = hasSelected;
  }

}
