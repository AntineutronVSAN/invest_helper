// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_socket_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebSocketChannelRequestModel _$WebSocketChannelRequestModelFromJson(
        Map<String, dynamic> json) =>
    WebSocketChannelRequestModel(
      id: json['id'] as int,
      method: $enumDecode(_$WebSocketMethodEnumMap, json['method']),
      params:
          (json['params'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$WebSocketChannelRequestModelToJson(
        WebSocketChannelRequestModel instance) =>
    <String, dynamic>{
      'method': _$WebSocketMethodEnumMap[instance.method],
      'params': instance.params,
      'id': instance.id,
    };

const _$WebSocketMethodEnumMap = {
  WebSocketMethod.SUBSCRIBE: 'SUBSCRIBE',
  WebSocketMethod.UNSUBSCRIBE: 'UNSUBSCRIBE',
};

AggTradeResponse _$AggTradeResponseFromJson(Map<String, dynamic> json) =>
    AggTradeResponse(
      eventType: json['e'] as String,
      eventTime: json['E'] as int,
      symbol: json['s'] as String,
      aggregateTradeId: json['a'] as int,
      price: json['p'] as String,
      quantity: json['q'] as String,
      firstTradeId: json['f'] as int,
      lastTradeId: json['l'] as int,
      tradeTime: json['T'] as int,
      buyerIsMarketMaker: json['m'] as bool,
    );

Map<String, dynamic> _$AggTradeResponseToJson(AggTradeResponse instance) =>
    <String, dynamic>{
      'e': instance.eventType,
      'E': instance.eventTime,
      's': instance.symbol,
      'a': instance.aggregateTradeId,
      'p': instance.price,
      'q': instance.quantity,
      'f': instance.firstTradeId,
      'l': instance.lastTradeId,
      'T': instance.tradeTime,
      'm': instance.buyerIsMarketMaker,
    };
