// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DietAllDataModel _$DietAllDataModelFromJson(Map<String, dynamic> json) =>
    DietAllDataModel(
      dietProducts: (json['dietProducts'] as List<dynamic>)
          .map((e) => DietProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      dietUsers: (json['dietUsers'] as List<dynamic>)
          .map((e) => DietUserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      dietJournal: (json['dietJournal'] as List<dynamic>)
          .map((e) => DietJournalModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      dietWeightJournal: (json['dietWeightJournal'] as List<dynamic>)
          .map(
              (e) => DietWeightJournalModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DietAllDataModelToJson(DietAllDataModel instance) =>
    <String, dynamic>{
      'dietProducts': instance.dietProducts.map((e) => e.toJson()).toList(),
      'dietUsers': instance.dietUsers.map((e) => e.toJson()).toList(),
      'dietJournal': instance.dietJournal.map((e) => e.toJson()).toList(),
      'dietWeightJournal':
          instance.dietWeightJournal.map((e) => e.toJson()).toList(),
    };

DietProductModel _$DietProductModelFromJson(Map<String, dynamic> json) =>
    DietProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      kkal: (json['kkal'] as num).toDouble(),
      squirrels: (json['squirrels'] as num).toDouble(),
      carbohydrates: (json['carbohydrates'] as num).toDouble(),
      fats: (json['fats'] as num).toDouble(),
      oneProductWeight: (json['oneProductWeight'] as num).toDouble(),
      oneProductWeightDescription:
          json['oneProductWeightDescription'] as String,
    );

Map<String, dynamic> _$DietProductModelToJson(DietProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'kkal': instance.kkal,
      'squirrels': instance.squirrels,
      'carbohydrates': instance.carbohydrates,
      'fats': instance.fats,
      'oneProductWeight': instance.oneProductWeight,
      'oneProductWeightDescription': instance.oneProductWeightDescription,
    };

DietUserModel _$DietUserModelFromJson(Map<String, dynamic> json) =>
    DietUserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      weight: (json['weight'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      targetWeight: (json['targetWeight'] as num).toDouble(),
      kkalNorm: (json['kkalNorm'] as num).toDouble(),
    );

Map<String, dynamic> _$DietUserModelToJson(DietUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'weight': instance.weight,
      'height': instance.height,
      'targetWeight': instance.targetWeight,
      'kkalNorm': instance.kkalNorm,
    };

DietJournalModel _$DietJournalModelFromJson(Map<String, dynamic> json) =>
    DietJournalModel(
      id: json['id'] as int,
      dateTime: json['dateTime'] as String,
      userId: json['userId'] as int,
      productId: json['productId'] as int,
      weight: (json['weight'] as num).toDouble(),
    );

Map<String, dynamic> _$DietJournalModelToJson(DietJournalModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dateTime': instance.dateTime,
      'userId': instance.userId,
      'productId': instance.productId,
      'weight': instance.weight,
    };

DietWeightJournalModel _$DietWeightJournalModelFromJson(
        Map<String, dynamic> json) =>
    DietWeightJournalModel(
      id: json['id'] as int,
      dateTime: json['dateTime'] as String,
      userId: json['userId'] as int,
      weight: (json['weight'] as num).toDouble(),
    );

Map<String, dynamic> _$DietWeightJournalModelToJson(
        DietWeightJournalModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dateTime': instance.dateTime,
      'userId': instance.userId,
      'weight': instance.weight,
    };
