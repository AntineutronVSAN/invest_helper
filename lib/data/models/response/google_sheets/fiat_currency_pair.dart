import 'package:json_annotation/json_annotation.dart';


part 'fiat_currency_pair.g.dart';

/// Класс описывает сущность категории покупки: еда, вода, развлечения и т.п.
@JsonSerializable()
class FiatCurrencyPair {
  final int id;
  final String pair;

  FiatCurrencyPair({
    required this.id,
    required this.pair,
  });

  factory FiatCurrencyPair.fromJson(Map<String, dynamic> json) => _$FiatCurrencyPairFromJson(json);
  Map<String, dynamic> toJson() => _$FiatCurrencyPairToJson(this);
}