

import 'package:invests_helper/data/models/response/binance/user_data_balance.dart';

/// Модель приложения баланса какой-либо криптовалюты
class AppCryptoBalance {

  /// Что за валюта
  final String asset;

  /// Сколько валюты
  final double count;

  /// Прайс
  double? price;

  /// Эквивалент в USDT
  double? inUsdt;

  AppCryptoBalance({required this.asset, required this.count, this.price, this.inUsdt});

  factory AppCryptoBalance.fromBinanceBalance(BinanceUserDataBalance balance) {
    return AppCryptoBalance(
        asset: balance.asset,
        count: double.parse(balance.free),
    );
  }

  void setNewPrice(double price) {
    this.price = price;
    inUsdt = count*price;
  }


  // TODO
  // factory AppCryptoBalance.fromByBitBalance(ByBitUserDataBalance balance)
  // factory AppCryptoBalance.composeBalances()
}


