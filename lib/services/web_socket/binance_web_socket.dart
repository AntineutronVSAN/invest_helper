


import 'package:web_socket_channel/io.dart';

class BinanceWebSocketService {

  /// Для групповой подписки на стримы ws не используется
  static const String baseWebSocketEndpoint =
  //'wss://stream.binance.com:9443/ws/';
      'wss://stream.binance.com:9443/';

  static const String webSocketTradeKey = '@trade';
  static const String webSocketAggKey = '@aggTrade';
  static const String webSocketStreamsEndPoint = 'stream?streams=';
  static const String webSocketStreamsDelimeter = '/';

  final AppWebSocketChannelObject priceChanger = AppWebSocketChannelObject();

  static int _idCounted=0;
  static int get nextId {_idCounted++; return _idCounted;}

  static final BinanceWebSocketService _singleton = BinanceWebSocketService._internal();

  factory BinanceWebSocketService() {
    return _singleton;
  }

  BinanceWebSocketService._internal();


  Future<void> initWebSocket({required List<String> symbols}) async {

    if (priceChanger.inited) return;

    String resultEndPoint = baseWebSocketEndpoint;
    resultEndPoint += webSocketStreamsEndPoint;
    for(var i=0; i<symbols.length; i++) {
      if (i == symbols.length-1) {
        resultEndPoint += (symbols[i] + webSocketAggKey);
        continue;
      }
      resultEndPoint += (symbols[i] + webSocketAggKey + webSocketStreamsDelimeter);
    }
    try {
      priceChanger.channel = IOWebSocketChannel.connect(
          Uri.parse(resultEndPoint));
      priceChanger.channel.stream.listen((message) {
        for(var i in priceChanger.listeners) {
          i.call(message);
        }
      });
      priceChanger.inited = true;
    } catch(e) {
      throw WebSocketChannelInitException(error: e);
    }

  }

  void listenPricesChanged(Function(dynamic) listener) {
    priceChanger.listeners.add(listener);
  }

  Future<void> closeWebSocket() async {
    if (priceChanger.inited) {
    }
    /*channel.sink.add('received!');
    channel.sink.close(status.goingAway);*/
  }


}

class AppWebSocketChannelObject {
  static const String endPoint = 'path';
  late final IOWebSocketChannel channel;
  final List<Function(dynamic)> listeners = [];
  bool inited = false;

  AppWebSocketChannelObject();

}


class WebSocketChannelInitException implements Exception {
  final dynamic error;
  WebSocketChannelInitException({required this.error});
}