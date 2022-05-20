import 'package:invests_helper/data/models/response/binance/user_data_balance.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_user_data_response.g.dart';

@JsonSerializable()
class BinanceUserDataResponse {
  final int makerCommission;
  final int takerCommission;
  final int buyerCommission;
  final int sellerCommission;

  final bool canTrade;
  final bool canWithdraw;
  final bool canDeposit;

  final int updateTime;

  final String accountType;

  final List<BinanceUserDataBalance> balances;

  final List<String> permissions;


  BinanceUserDataResponse({
    required this.makerCommission,
    required this.takerCommission,
    required this.buyerCommission,
    required this.sellerCommission,
    required this.accountType,
    required this.canTrade,
    required this.canWithdraw,
    required this.canDeposit,
    required this.updateTime,
    required this.balances,
    required this.permissions,
});

  factory BinanceUserDataResponse.fromJson(Map<String, dynamic> json) => _$BinanceUserDataResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BinanceUserDataResponseToJson(this);

}

