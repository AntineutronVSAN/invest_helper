import 'package:intl/intl.dart';

class IHTimeService {

  static const String pattern = 'dd.MM.yyyy';

  static DateTime getNow() {
    return DateTime.now();
  }

  static String getNowStr() {
    return DateTime.now().toString();
  }

  static String getNowFormatted() {

    return DateFormat(pattern).format(getNow());
  }


}