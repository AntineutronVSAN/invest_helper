// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpendGoogleSheetModel _$SpendGoogleSheetModelFromJson(
        Map<String, dynamic> json) =>
    SpendGoogleSheetModel(
      id: json['id'] as int,
      value: (json['value'] as num).toDouble(),
      comment: json['comment'] as String,
      currency: json['currency'] as int,
      category: json['category'] as int,
      date: json['date'] as String,
    );

Map<String, dynamic> _$SpendGoogleSheetModelToJson(
        SpendGoogleSheetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'value': instance.value,
      'currency': instance.currency,
      'comment': instance.comment,
      'category': instance.category,
    };
