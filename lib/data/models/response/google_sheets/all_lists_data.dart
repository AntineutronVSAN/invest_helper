import 'package:invests_helper/data/models/response/google_sheets/fiat_currency.dart';
import 'package:invests_helper/data/models/response/google_sheets/fiat_currency_pair.dart';
import 'package:invests_helper/data/models/response/google_sheets/spend_category.dart';
import 'package:json_annotation/json_annotation.dart';

part 'all_lists_data.g.dart';

/// Класс описывает основные категориальные сущности из гугл таблиц
@JsonSerializable()
class AllListsGoogleSheetData {

  final List<FiatCurrency> fiatCurrencies;
  final List<FiatCurrencyPair> fiatActivesPairs;
  final List<SpendCategory> spendCategories;

  AllListsGoogleSheetData({
    required this.fiatCurrencies,
    required this.fiatActivesPairs,
    required this.spendCategories,
  });

  factory AllListsGoogleSheetData.fromJson(Map<String, dynamic> json) =>
      _$AllListsGoogleSheetDataFromJson(json);

  Map<String, dynamic> toJson() => _$AllListsGoogleSheetDataToJson(this);
}
