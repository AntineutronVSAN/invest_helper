
import 'package:json_annotation/json_annotation.dart';


part 'spend_model.g.dart';

/// Класс описывает сущность траты
@JsonSerializable()
class SpendGoogleSheetModel {
  final int id;
  final String date;
  final double value;
  final int currency;
  final String comment;
  final int category;

  SpendGoogleSheetModel({
    required this.id,
    required this.value,
    required this.comment,
    required this.currency,
    required this.category,
    required this.date,
  });

  factory SpendGoogleSheetModel.fromJson(Map<String, dynamic> json) => _$SpendGoogleSheetModelFromJson(json);
  Map<String, dynamic> toJson() => _$SpendGoogleSheetModelToJson(this);

}