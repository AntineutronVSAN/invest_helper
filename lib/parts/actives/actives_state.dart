

import 'package:invests_helper/base/bloc_state_base.dart';
import 'package:invests_helper/data/models/app_models/app_crypto_balance.dart';

class ActivesState extends BaseState<ActivesState> {

  final List<AppCryptoBalance> balances;

  final bool isGoogleSheetsActive;
  final bool isBinanceActive;

  final double totalBalance;

  final int totalOrders;

  ActivesState({
    required this.balances,
    this.isGoogleSheetsActive = false,
    this.isBinanceActive = false,
    this.totalBalance = 0.0,
    this.totalOrders = 0,
  });

  ActivesState copyWith({
    List<AppCryptoBalance>? balances,
    bool? isGoogleSheetsActive,
    bool? isBinanceActive,
    double? totalBalance,
    int? totalOrders,
  }) {
    return ActivesState(
        balances: balances ?? this.balances,
        isGoogleSheetsActive: isGoogleSheetsActive ?? this.isGoogleSheetsActive,
        isBinanceActive: isBinanceActive ?? this.isBinanceActive,
        totalBalance: totalBalance ?? this.totalBalance,
        totalOrders: totalOrders ?? this.totalOrders,
    );
  }

}