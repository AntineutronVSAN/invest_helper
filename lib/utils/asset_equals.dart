

extension CryptoStringUtils on String {

  bool isEqualAsset(String other) {
    if (other == this) return true;

    final lowerThis = toLowerCase().replaceAll('/', '');
    final lowerOther = other.toLowerCase().replaceAll('/', '');

    if (lowerThis == lowerOther) return true;

    final withoutUsdtThis = lowerThis.replaceAll('usdt', '');
    final withoutUsdtOther = lowerOther.replaceAll('usdt', '');

    if (withoutUsdtThis == withoutUsdtOther) return true;

    return false;
  }

}