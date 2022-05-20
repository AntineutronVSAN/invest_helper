import 'package:flutter/material.dart';
import 'package:invests_helper/data/models/app_models/app_crypto_balance.dart';
import 'package:invests_helper/theme/texts.dart';
import 'package:invests_helper/theme/ui_colors.dart';
import 'package:invests_helper/utils/icon_by_crypto.dart';

class AppBalanceCard extends StatefulWidget {
  final AppCryptoBalance balance;

  const AppBalanceCard({Key? key, required this.balance}) : super(key: key);

  @override
  State<AppBalanceCard> createState() => _AppBalanceCardState();
}

class _AppBalanceCardState extends State<AppBalanceCard> {

  double lastPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          color: AppColors.secondColor,
          shadowColor: AppColors.secondColor,
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CryptoIconProvider.getIconByCryptoAsset(asset: widget.balance.asset),
              title: AppTexts.balanceCardDescriptionText(text: widget.balance.asset),
              subtitle: AppTexts.balanceCardDescriptionText(
                  text: widget.balance.count.toString()),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppColoredPriceText(
                    text: _getCryptoPriceText(),
                    isUp: _getUpDownState(),
                  ),//isUp: Random().nextInt(100) > 50,),
                  //AppTexts.balanceCardDescriptionText(
                  //    text: _getCryptoPriceText()),
                  AppTexts.balanceCardDescriptionText(text: _getInUsdtText()),
                ],
              ),
            ),
          )),
    );
  }

  bool _getUpDownState() {

    final cryptoPrice = widget.balance.price;
    if (cryptoPrice == null) return false;

    if (cryptoPrice > lastPrice) {
      lastPrice = cryptoPrice;
      return true;
    }
    lastPrice = cryptoPrice;
    return false;
  }

  String _getCryptoPriceText() {
    final cryptoPrice = widget.balance.price;
    if (cryptoPrice == null) return '';
    return '${cryptoPrice.toStringAsFixed(2)} ${widget.balance.asset}/USD';
  }

  String _getInUsdtText() {
    final inUsdt = widget.balance.inUsdt;
    if (inUsdt == null) return '';
    return '~${inUsdt.toStringAsFixed(1)} USD';
  }
}
