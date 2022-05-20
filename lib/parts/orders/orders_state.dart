import 'package:invests_helper/base/bloc_state_base.dart';
import 'package:invests_helper/data/models/response/google_sheets/google_sheet_order.dart';

class OrdersState extends BaseState<OrdersState> {

  /// Перовначальный ордера
  final List<GoogleSheetOrder> orders;
  /// Прайсы по кажому ордеру
  final List<String> currentPrices;
  /// Процент до конца по каждому ордеру и по каждой части
  /// Чем больше процент тем хуже
  /// Если процент равн 0 - значит пора продавать
  final List<List<SellPieceInfo>> sellData;

  final bool confirmMeanLoading;

  OrdersState({
    required this.orders,
    required this.currentPrices,
    required this.sellData,
    this.confirmMeanLoading = false,
  });

  OrdersState copyWith({
    List<GoogleSheetOrder>? orders,
    List<String>? currentPrices,
    List<List<SellPieceInfo>>? sellData,
    bool? confirmMeanLoading,
}) {
    return OrdersState(
      orders: orders ?? this.orders,
      currentPrices: currentPrices ?? this.currentPrices,
      sellData: sellData ?? this.sellData,
      confirmMeanLoading: confirmMeanLoading ?? this.confirmMeanLoading,
    );
  }

  factory OrdersState.empty() {
    return OrdersState(
      orders: [],
      currentPrices: [],
      sellData: [],
    );
  }

}

/// Инфо о продажах
class SellPieceInfo {

  /// Текущий профит в usd
  final double currentProfitUsd;
  /// Ожидаемый
  final double plannedProfitUsd;
  /// Текущий профит %
  final double currentPercent;
  /// Текущий профит %
  final double plannedPercent;

  /// % До совершения сделки
  final double deltaPercent;

  final double deltaSellValue;

  final double pieceUsdValue;

  SellPieceInfo({
    required this.currentProfitUsd,
    required this.plannedProfitUsd,
    required this.currentPercent,
    required this.deltaPercent,
    required this.plannedPercent,
    required this.deltaSellValue,
    required this.pieceUsdValue,
  });

}
