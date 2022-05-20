// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buys_cash_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuysCashStatus _$BuysCashStatusFromJson(Map<String, dynamic> json) =>
    BuysCashStatus(
      id: json['id'] as int,
      description: json['description'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$BuysCashStatusToJson(BuysCashStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };
