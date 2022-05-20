

import 'package:invests_helper/utils/time_service.dart';

class HumanDateTime {

  static String convertStr({required String dateTimeStr}) {
    final dateTime = DateTime.parse(dateTimeStr);
    return convertDt(dateTime: dateTime);
  }

  static String convertDt({required DateTime dateTime}) {

    final now = IHTimeService.getNow();
    final dt = now.difference(dateTime);
    if (dt.inDays < 1) {
      return 'Менее дня назад';
    }
    if (dt.inDays == 7) {
      return 'Неделя назад';
    }
    if (dt.inDays > 1 && dt.inDays < 30) {
      return 'Менее месяца назад';
    }
    if (dt.inDays == 30) {
      return 'Месяц назад';
    }
    return '${dt.inDays ~/ 30} месяцев назад';
  }

}