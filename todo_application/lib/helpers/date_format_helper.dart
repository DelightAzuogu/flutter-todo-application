import 'package:date_format/date_format.dart';

class DateFormatHelper {
  DateFormatHelper._();

  static String formatDateToString(DateTime date) {
    final currentDate = DateTime.now();
    if (date.day == currentDate.day && date.month == currentDate.month && date.year == currentDate.year) {
      return 'Today';
    } else if (date.day == currentDate.day + 1 && date.month == currentDate.month && date.year == currentDate.year) {
      return 'Tomorrow';
    } else {
      return formatDate(date, [dd, ' ', MM, ' ', yyyy]);
    }
  }

  static String formatTimeToString(DateTime date) {
    return formatDate(date, [HH, ':', nn]);
  }

  static String formatDateTimeToString(DateTime date) {
    return formatDate(date, [dd, ' ', M, ', ', yyyy, ' ', HH, ':', nn]);
  }

  static DateTime convertToUtc(DateTime localDate) {
    return localDate.toUtc();
  }
}
