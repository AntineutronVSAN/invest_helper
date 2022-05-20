import 'package:json_annotation/json_annotation.dart';


part 'buys_cash.g.dart';

/// Класс описывает сущность покупки фиатной валюты
@JsonSerializable()
class BuysCash {
  final int id;
  final String dateTime;
  final String pair;
  final double course;
  final double count;
  final String whereKeep;
  final int status;

  BuysCash({
    required this.id,
    required this.dateTime,
    required this.pair,
    required this.course,
    required this.count,
    required this.whereKeep,
    required this.status,
  });

  factory BuysCash.fromJson(Map<String, dynamic> json) => _$BuysCashFromJson(json);
  Map<String, dynamic> toJson() => _$BuysCashToJson(this);
}
