// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data_balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BinanceUserDataBalance _$BinanceUserDataBalanceFromJson(
        Map<String, dynamic> json) =>
    BinanceUserDataBalance(
      asset: json['asset'] as String,
      free: json['free'] as String,
      locked: json['locked'] as String,
    );

Map<String, dynamic> _$BinanceUserDataBalanceToJson(
        BinanceUserDataBalance instance) =>
    <String, dynamic>{
      'asset': instance.asset,
      'free': instance.free,
      'locked': instance.locked,
    };
