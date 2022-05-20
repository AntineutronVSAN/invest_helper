// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BinanceUserDataResponse _$BinanceUserDataResponseFromJson(
        Map<String, dynamic> json) =>
    BinanceUserDataResponse(
      makerCommission: json['makerCommission'] as int,
      takerCommission: json['takerCommission'] as int,
      buyerCommission: json['buyerCommission'] as int,
      sellerCommission: json['sellerCommission'] as int,
      accountType: json['accountType'] as String,
      canTrade: json['canTrade'] as bool,
      canWithdraw: json['canWithdraw'] as bool,
      canDeposit: json['canDeposit'] as bool,
      updateTime: json['updateTime'] as int,
      balances: (json['balances'] as List<dynamic>)
          .map(
              (e) => BinanceUserDataBalance.fromJson(e as Map<String, dynamic>))
          .toList(),
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$BinanceUserDataResponseToJson(
        BinanceUserDataResponse instance) =>
    <String, dynamic>{
      'makerCommission': instance.makerCommission,
      'takerCommission': instance.takerCommission,
      'buyerCommission': instance.buyerCommission,
      'sellerCommission': instance.sellerCommission,
      'canTrade': instance.canTrade,
      'canWithdraw': instance.canWithdraw,
      'canDeposit': instance.canDeposit,
      'updateTime': instance.updateTime,
      'accountType': instance.accountType,
      'balances': instance.balances.map((e) => e.toJson()).toList(),
      'permissions': instance.permissions,
    };
