import 'package:json_annotation/json_annotation.dart';

part 'symbol_data_response.g.dart';

@JsonSerializable()
class SymbolData {
  final String symbol;
  final String price;

  SymbolData({required this.price, required this.symbol});

  factory SymbolData.fromJson(Map<String, dynamic> json) => _$SymbolDataFromJson(json);
  Map<String, dynamic> toJson() => _$SymbolDataToJson(this);
}