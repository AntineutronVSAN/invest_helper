import 'package:invests_helper/base/invest_helper/object_with_datetime.dart';
import 'package:invests_helper/base/invest_helper/object_with_id.dart';
import 'package:json_annotation/json_annotation.dart';

part 'diet.g.dart';

@JsonSerializable()
class DietAllDataModel {
  final List<DietProductModel> dietProducts;
  final List<DietUserModel> dietUsers;
  final List<DietJournalModel> dietJournal;
  final List<DietWeightJournalModel> dietWeightJournal;

  DietAllDataModel({
    required this.dietProducts,
    required this.dietUsers,
    required this.dietJournal,
    required this.dietWeightJournal,
  });

  factory DietAllDataModel.fromJson(Map<String, dynamic> json) => _$DietAllDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$DietAllDataModelToJson(this);

}

@JsonSerializable()
class DietProductModel implements AppModelWithId {
  final int id;
  final String name;
  final String description;
  final double price;
  final double kkal;
  final double squirrels;
  final double carbohydrates;
  final double fats;

  DietProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.kkal,
    required this.squirrels,
    required this.carbohydrates,
    required this.fats,
  });

  @override
  int getId() {
    return id;
  }

  factory DietProductModel.fromJson(Map<String, dynamic> json) => _$DietProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$DietProductModelToJson(this);


}

@JsonSerializable()
class DietUserModel implements AppModelWithId {
  final int id;
  final String name;
  final double weight;
  final double height;
  final double targetWeight;
  final double kkalNorm;

  DietUserModel({
    required this.id,
    required this.name,
    required this.weight,
    required this.height,
    required this.targetWeight,
    required this.kkalNorm,
  });

  @override
  int getId() {
    return id;
  }

  factory DietUserModel.fromJson(Map<String, dynamic> json) => _$DietUserModelFromJson(json);
  Map<String, dynamic> toJson() => _$DietUserModelToJson(this);
}

@JsonSerializable()
class DietJournalModel implements AppModelWithDateTime, AppModelWithId {
  final int id;
  final String dateTime;
  final int userId;
  final int productId;
  final double weight;

  DietJournalModel({
    required this.id,
    required this.dateTime,
    required this.userId,
    required this.productId,
    required this.weight,
  });

  @override
  int getId() {
    return id;
  }

  @override
  String getEntryDateTimeStr() {
    return dateTime;
  }

  factory DietJournalModel.fromJson(Map<String, dynamic> json) => _$DietJournalModelFromJson(json);
  Map<String, dynamic> toJson() => _$DietJournalModelToJson(this);
}

@JsonSerializable()
class DietWeightJournalModel implements AppModelWithDateTime, AppModelWithId {
  final int id;
  final String dateTime;
  final int userId;
  final double weight;

  DietWeightJournalModel({
    required this.id,
    required this.dateTime,
    required this.userId,
    required this.weight,
  });

  @override
  int getId() {
    return id;
  }

  @override
  String getEntryDateTimeStr() {
    return dateTime;
  }

  factory DietWeightJournalModel.fromJson(Map<String, dynamic> json) => _$DietWeightJournalModelFromJson(json);
  Map<String, dynamic> toJson() => _$DietWeightJournalModelToJson(this);

}