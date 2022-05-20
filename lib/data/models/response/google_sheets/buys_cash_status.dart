import 'package:json_annotation/json_annotation.dart';

part 'buys_cash_status.g.dart';

@JsonSerializable()
class BuysCashStatus {
  final int id;
  final String name;
  final String description;

  BuysCashStatus({
    required this.id,
    required this.description,
    required this.name,
  });

  factory BuysCashStatus.fromJson(Map<String, dynamic> json) => _$BuysCashStatusFromJson(json);
  Map<String, dynamic> toJson() => _$BuysCashStatusToJson(this);
}