// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_lists_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllListsGoogleSheetData _$AllListsGoogleSheetDataFromJson(
        Map<String, dynamic> json) =>
    AllListsGoogleSheetData(
      fiatCurrencies: (json['fiatCurrencies'] as List<dynamic>)
          .map((e) => FiatCurrency.fromJson(e as Map<String, dynamic>))
          .toList(),
      fiatActivesPairs: (json['fiatActivesPairs'] as List<dynamic>)
          .map((e) => FiatCurrencyPair.fromJson(e as Map<String, dynamic>))
          .toList(),
      spendCategories: (json['spendCategories'] as List<dynamic>)
          .map((e) => SpendCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AllListsGoogleSheetDataToJson(
        AllListsGoogleSheetData instance) =>
    <String, dynamic>{
      'fiatCurrencies': instance.fiatCurrencies.map((e) => e.toJson()).toList(),
      'fiatActivesPairs':
          instance.fiatActivesPairs.map((e) => e.toJson()).toList(),
      'spendCategories':
          instance.spendCategories.map((e) => e.toJson()).toList(),
    };
