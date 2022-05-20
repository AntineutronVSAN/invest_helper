import 'package:invests_helper/base/bloc_base.dart';
import 'package:invests_helper/base/bloc_event_base.dart';
import 'package:invests_helper/data/models/response/binance/symbol_data_response.dart';
import 'package:intl/intl.dart';

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

}
