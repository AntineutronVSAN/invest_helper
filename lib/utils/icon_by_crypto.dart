


import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:invests_helper/theme/ui_colors.dart';

/*

SvgPicture.asset(
  assetName,
  color: Colors.red,
  semanticsLabel: 'A red up arrow'
);

*/

class CryptoIconProvider {

  static const String bitcoinAssetPath = 'asd';

  static Widget getIconByCryptoAsset({
    double size = 50.0,
    required String asset,
  }) {

    Widget? svgBody;

    final assetName = asset.toLowerCase();

    if (assetName.contains('btc')) {
      svgBody = SvgPicture.asset(
        'assets/icons/ic_bitcoin.svg',
      );
    } else if (assetName.contains('eth')) {
      svgBody = SvgPicture.asset(
        'assets/icons/ic_ethereum.svg',
        //color: AppColors.yellowColor,
      );
    } else {
      svgBody = SvgPicture.asset(
        'assets/icons/crypto_currency.svg',
        color: AppColors.greenColor,
      );
    }

    return SizedBox(
      width: size,
      height: size,

      child: svgBody,
    );
  }




}