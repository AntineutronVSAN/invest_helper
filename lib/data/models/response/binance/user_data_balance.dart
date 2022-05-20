import 'package:json_annotation/json_annotation.dart';

part 'user_data_balance.g.dart';

@JsonSerializable()
class BinanceUserDataBalance {

  final String asset;
  final String free;
  final String locked;

  BinanceUserDataBalance({
    required this.asset,
    required this.free,
    required this.locked,
  });

  factory BinanceUserDataBalance.fromJson(Map<String, dynamic> json) => _$BinanceUserDataBalanceFromJson(json);
  Map<String, dynamic> toJson() => _$BinanceUserDataBalanceToJson(this);


}