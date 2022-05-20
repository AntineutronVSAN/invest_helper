// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buys_cash.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuysCash _$BuysCashFromJson(Map<String, dynamic> json) => BuysCash(
      id: json['id'] as int,
      dateTime: json['dateTime'] as String,
      pair: json['pair'] as String,
      course: (json['course'] as num).toDouble(),
      count: (json['count'] as num).toDouble(),
      whereKeep: json['whereKeep'] as String,
      status: json['status'] as int,
    );

Map<String, dynamic> _$BuysCashToJson(BuysCash instance) => <String, dynamic>{
      'id': instance.id,
      'dateTime': instance.dateTime,
      'pair': instance.pair,
      'course': instance.course,
      'count': instance.count,
      'whereKeep': instance.whereKeep,
      'status': instance.status,
    };
