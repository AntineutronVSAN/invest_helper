import 'package:invests_helper/base/bloc_base.dart';
import 'package:invests_helper/base/bloc_event_base.dart';
import 'package:invests_helper/base/invest_helper/object_with_datetime.dart';
import 'package:invests_helper/base/invest_helper/object_with_id.dart';
import 'package:invests_helper/data/models/response/binance/symbol_data_response.dart';
import 'package:intl/intl.dart';
import 'package:invests_helper/utils/time_service.dart';

/// Bloc приложения invest helper
abstract class InvestHelperBloc<E extends GlobalEvent, S, LS> extends AdvancedBlocBase<E, S, LS> {
  InvestHelperBloc(S initialState) : super(initialState);

  final String googleSheetOrdersDateFormat = 'dd.MM.yyyy';

  /// Отфильтровать все валюты, которые не USDT
  List<SymbolData> filterNonUSDTSymbols(List<SymbolData> data) {

    final result = data.where((element) {
      final asset = element.symbol;
      final assetLength = asset.length;
      if (assetLength <= 5) return false;
      final slice = asset.substring(assetLength-4, assetLength);
      if (slice.toLowerCase() != 'usdt') return false;
      return true;
    }).toList();

    return result;
  }

  /// Метод предназначен для построения маркеров для календаря
  /// По сути это группировка данных по дате
  Map<String, List<T>> buildMarkersCount<T extends AppModelWithDateTime>({required List<T> data}) {
    final result = <String, List<T>>{};
    for(var dataEntry in data) {
      final dataEntryDateTime = DateTime.parse(dataEntry.getEntryDateTimeStr());
      final dataEntryStr = IHTimeService.onlyDayStr(
          dateTime: dataEntryDateTime);
      final hasKey = result.containsKey(dataEntryStr);
      if (!hasKey) {
        result[dataEntryStr] = [dataEntry];
        continue;
      }
      result[dataEntryStr]!.add(dataEntry);
    }

    return result;

  }

  /// Сделать хеш мапу из списка для быстрого поиска по id
  Map<int, T> buildMapFromList<T extends AppModelWithId>({required List<T> data}) {
    final res = <int, T>{};
    for(var i in data) {
      res[i.getId()] = i;
    }
    return res;
  }

}
