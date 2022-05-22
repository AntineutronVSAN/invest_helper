// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spend_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpendCategory _$SpendCategoryFromJson(Map<String, dynamic> json) =>
    SpendCategory(
      description: json['description'] as String,
      id: json['id'] as int,
      name: json['name'] as String,
    );

Map<String, dynamic> _$SpendCategoryToJson(SpendCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };
