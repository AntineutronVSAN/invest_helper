// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symbol_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SymbolData _$SymbolDataFromJson(Map<String, dynamic> json) => SymbolData(
      price: json['price'] as String,
      symbol: json['symbol'] as String,
    );

Map<String, dynamic> _$SymbolDataToJson(SymbolData instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'price': instance.price,
    };
