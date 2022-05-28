import 'package:intl/intl.dart';

class IHTimeService {

  static const String pattern = 'dd.MM.yyyy';
  static const String dateTimePattern = 'dd.MM.yyyy HH:mm:ss';
  static const String timePattern = 'HH:mm:ss';

  static DateTime getNow() {
    return DateTime.now();
  }

  static String getNowStr() {
    return DateTime.now().toString();
  }

  static String getNowFormatted() {
    return DateFormat(pattern).format(getNow());
  }
  static String getNowFormattedWithTime() {
    return DateFormat(dateTimePattern).format(getNow());
  }

  static DateTime onlyDay({required DateTime dateTime}) {
    final res = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return res;
  }

  static String onlyDayStr({required DateTime dateTime}) {
    final res = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return res.toString();
  }

  static String onlyTimeFormatted({required DateTime dateTime}) {
    return DateFormat(timePattern).format(dateTime);
  }

  static String onlyTimeFormattedFromStr({required String dateTime}) {
    return DateFormat(timePattern).format(DateTime.parse(dateTime));
  }

}