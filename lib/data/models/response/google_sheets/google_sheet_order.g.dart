// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_sheet_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleSheetOrder _$GoogleSheetOrderFromJson(Map<String, dynamic> json) =>
    GoogleSheetOrder(
      orderNumber: json['orderNumber'] as int,
      buyedCource: (json['buyedCource'] as num).toDouble(),
      orderState: json['orderState'] as String,
      comment: json['comment'] as String,
      dateTime: json['dateTime'] as String,
      whereCrypto: json['whereCrypto'] as String,
      pair: json['pair'] as String,
      buyedValue: (json['buyedValue'] as num).toDouble(),
      usdEq: (json['usdEq'] as num).toDouble(),
      comission: json['comission'] as String,
      orderSellData: (json['orderSellData'] as List<dynamic>)
          .map((e) => OrderSellData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GoogleSheetOrderToJson(GoogleSheetOrder instance) =>
    <String, dynamic>{
      'orderNumber': instance.orderNumber,
      'orderState': instance.orderState,
      'comment': instance.comment,
      'dateTime': instance.dateTime,
      'whereCrypto': instance.whereCrypto,
      'pair': instance.pair,
      'buyedValue': instance.buyedValue,
      'buyedCource': instance.buyedCource,
      'usdEq': instance.usdEq,
      'comission': instance.comission,
      'orderSellData': instance.orderSellData.map((e) => e.toJson()).toList(),
    };

OrderSellData _$OrderSellDataFromJson(Map<String, dynamic> json) =>
    OrderSellData(
      minIncomePercent: json['minIncomePercent'] as int,
      minPiceSellPercent: json['minPiceSellPercent'] as int,
      planedSellCource: (json['planedSellCource'] as num).toDouble(),
      planedSellValue: (json['planedSellValue'] as num).toDouble(),
      hasSellDate: json['hasSellDate'] as String?,
      hasSellCourse: (json['hasSellCourse'] as num?)?.toDouble(),
      totalPredicted: (json['totalPredicted'] as num).toDouble(),
      totalFact: (json['totalFact'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderSellDataToJson(OrderSellData instance) =>
    <String, dynamic>{
      'minIncomePercent': instance.minIncomePercent,
      'minPiceSellPercent': instance.minPiceSellPercent,
      'planedSellCource': instance.planedSellCource,
      'planedSellValue': instance.planedSellValue,
      'hasSellDate': instance.hasSellDate,
      'hasSellCourse': instance.hasSellCourse,
      'totalPredicted': instance.totalPredicted,
      'totalFact': instance.totalFact,
    };
