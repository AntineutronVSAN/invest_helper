import 'package:json_annotation/json_annotation.dart';


part 'spend_category.g.dart';

/// Класс описывает сущность категории покупки: еда, вода, развлечения и т.п.
@JsonSerializable()
class SpendCategory {
  final int id;
  final String name;
  final String description;

  SpendCategory({
    required this.description,
    required this.id,
    required this.name,
  });

  factory SpendCategory.fromJson(Map<String, dynamic> json) => _$SpendCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$SpendCategoryToJson(this);
}
