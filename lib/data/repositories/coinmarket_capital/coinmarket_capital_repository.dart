



import 'package:invests_helper/data/repositories/coinmarket_capital/coin_market_acpital_base.dart';
import 'package:invests_helper/data/repositories/repository_base.dart';
import 'package:invests_helper/secure_data.dart';

class CoinMarketCapRepository extends BaseBackendClient implements BaseCoinMarketCapRepository {

  // todo
  static const String apiKey = IHSecureData.coinMarketCapitalApiKey;

}