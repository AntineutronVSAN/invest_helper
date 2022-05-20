import 'package:json_annotation/json_annotation.dart';

/*{
  "method": "SUBSCRIBE",
  "params": [
    "btcusdt@aggTrade",
    "btcusdt@depth"
  ],
  "id": 1
}*/
part 'web_socket_models.g.dart';

@JsonSerializable()
class WebSocketChannelRequestModel {

  final WebSocketMethod method;
  final List<String> params;
  final int id;

  WebSocketChannelRequestModel({
    required this.id,
    required this.method,
    required this.params
  });

  factory WebSocketChannelRequestModel.fromJson(Map<String, dynamic> json) => _$WebSocketChannelRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$WebSocketChannelRequestModelToJson(this);
}

/*{
  "e": "aggTrade",  // Event type
  "E": 123456789,   // Event time
  "s": "BNBBTC",    // Symbol
  "a": 12345,       // Aggregate trade ID
  "p": "0.001",     // Price
  "q": "100",       // Quantity
  "f": 100,         // First trade ID
  "l": 105,         // Last trade ID
  "T": 123456785,   // Trade time
  "m": true,        // Is the buyer the market maker?
  "M": true         // Ignore
}*/
@JsonSerializable()
class AggTradeResponse {
  @JsonKey(name: 'e')
  final String eventType;

  @JsonKey(name: 'E')
  final int eventTime;

  @JsonKey(name: 's')
  final String symbol;

  @JsonKey(name: 'a')
  final int aggregateTradeId;

  @JsonKey(name: 'p')
  final String price;

  @JsonKey(name: 'q')
  final String quantity;

  @JsonKey(name: 'f')
  final int firstTradeId;

  @JsonKey(name: 'l')
  final int lastTradeId;

  @JsonKey(name: 'T')
  final int tradeTime;

  @JsonKey(name: 'm')
  final bool buyerIsMarketMaker;

  AggTradeResponse({
    required this.eventType,
    required this.eventTime,
    required this.symbol,
    required this.aggregateTradeId,
    required this.price,
    required this.quantity,
    required this.firstTradeId,
    required this.lastTradeId,
    required this.tradeTime,
    required this.buyerIsMarketMaker,
  });

  factory AggTradeResponse.fromJson(Map<String, dynamic> json) => _$AggTradeResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AggTradeResponseToJson(this);
}


enum WebSocketMethod {
  SUBSCRIBE,
  UNSUBSCRIBE,
  // todo там ещё куча методов

}