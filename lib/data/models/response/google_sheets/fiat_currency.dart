import 'package:json_annotation/json_annotation.dart';


part 'fiat_currency.g.dart';

/// Класс описывает сущность категории покупки: еда, вода, развлечения и т.п.
@JsonSerializable()
class FiatCurrency {
  final int id;
  final String asset;

  FiatCurrency({
    required this.id,
    required this.asset,
  });

  factory FiatCurrency.fromJson(Map<String, dynamic> json) => _$FiatCurrencyFromJson(json);
  Map<String, dynamic> toJson() => _$FiatCurrencyToJson(this);
}