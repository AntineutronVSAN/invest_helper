import 'package:json_annotation/json_annotation.dart';

part 'google_sheet_order.g.dart';

@JsonSerializable()
class GoogleSheetOrder {
  final int orderNumber;

  /// Усреднён
  /// Активен
  /// на половину закрыт
  /// закрыт
  final String orderState;

  /// Коммент
  final String comment;
  final String dateTime;

  /// Гден находится крипта
  final String whereCrypto;

  /// Пара
  final String pair;

  /// Сколько валюты куплено
  final double buyedValue;

  /// По какому курсу
  final double buyedCource;

  /// Экв usd
  final double usdEq;

  /// Сколько было комиссии
  final String comission;

  /// Данные частей продажи
  List<OrderSellData> orderSellData;

  GoogleSheetOrder({
    required this.orderNumber,
    required this.buyedCource,
    required this.orderState,
    required this.comment,
    required this.dateTime,
    required this.whereCrypto,
    required this.pair,
    required this.buyedValue,
    required this.usdEq,
    required this.comission,
    required this.orderSellData,
  });

  factory GoogleSheetOrder.fromJson(Map<String, dynamic> json) => _$GoogleSheetOrderFromJson(json);
  Map<String, dynamic> toJson() => _$GoogleSheetOrderToJson(this);
}

@JsonSerializable()
class OrderSellData {
  /// На сколько должна вырасти цена, что бы продать
  final int minIncomePercent;

  /// Какая часть должна быть продана, если цена стара больше или равно
  /// [minIncomePercent]
  final int minPiceSellPercent;

  /// При каком курсе нужно продать
  final double planedSellCource;

  /// Сколько продать
  final double planedSellValue;

  /// Если часть уже продана, то когда
  final String? hasSellDate;

  /// Если часть уже продана, то по какому курсу
  final double? hasSellCourse;

  /// Итог продажи рассчётный
  final double totalPredicted;

  /// Итог продажи фактический
  final double totalFact;

  OrderSellData({
    required this.minIncomePercent,
    required this.minPiceSellPercent,
    required this.planedSellCource,
    required this.planedSellValue,
    this.hasSellDate,
    this.hasSellCourse,
    required this.totalPredicted,
    required this.totalFact,
  });

  factory OrderSellData.fromJson(Map<String, dynamic> json) => _$OrderSellDataFromJson(json);
  Map<String, dynamic> toJson() => _$OrderSellDataToJson(this);

}

enum OrderStateType {

  active,
  meaned,
  halfDone,
  done,

  unknown,
}

extension StrToOrderType on String {

  OrderStateType toOrderStateType() {

    switch(this) {
      case 'активен':
        return OrderStateType.active;
      case 'усреднён':
        return OrderStateType.meaned;
      case 'завершён':
        return OrderStateType.done;
      case 'на половину закрыт':
        return OrderStateType.halfDone;
    }

    return OrderStateType.unknown;

  }

}