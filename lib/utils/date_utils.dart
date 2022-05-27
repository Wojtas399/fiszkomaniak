import 'package:fiszkomaniak/models/date_model.dart';

class DateUtils {
  static int compareDates(Date date1, Date date2) {
    if (date1.year == date2.year) {
      if (date1.month == date2.month) {
        if (date1.day == date2.day) {
          return 0;
        } else {
          return date1.day > date2.day ? 1 : -1;
        }
      } else {
        return date1.month > date2.month ? 1 : -1;
      }
    } else {
      return date1.year > date2.year ? 1 : -1;
    }
  }

  static bool isPastDate(Date? date) {
    if (date == null) {
      return false;
    }
    return compareDates(date, Date.now()) == -1;
  }

  static bool isTodayDate(Date? date) {
    if (date == null) {
      return false;
    }
    return compareDates(date, Date.now()) == 0;
  }

  static List<Date> getDaysInARow(
    Date fromDate,
    List<Date> dates,
  ) {
    final List<Date> days = [];
    int daysInARow = 0;
    int counter = 0;
    final List<DateTime> sortedDates = [...dates]
        .map((date) => DateTime(date.year, date.month, date.day))
        .toList();
    sortedDates.sort();
    final List<Date> datesInDescendingOrder = sortedDates
        .map((date) => Date(year: date.year, month: date.month, day: date.day))
        .toList()
        .reversed
        .toList();
    while (counter < datesInDescendingOrder.length &&
        _daysBetween(fromDate, datesInDescendingOrder[counter]) == daysInARow) {
      days.add(datesInDescendingOrder[counter]);
      daysInARow++;
      counter++;
    }
    return days;
  }

  static List<Date> getDaysFromWeek(Date dayFromWeek) {
    DateTime firstDayOfWeek = DateTime(
      dayFromWeek.year,
      dayFromWeek.month,
      dayFromWeek.day,
    ).subtract(Duration(days: dayFromWeek.weekday - 1));
    firstDayOfWeek = DateTime(
      firstDayOfWeek.year,
      firstDayOfWeek.month,
      firstDayOfWeek.day,
    );
    return List.generate(
      7,
      (index) => firstDayOfWeek.add(Duration(days: index)),
    )
        .map((date) => Date(year: date.year, month: date.month, day: date.day))
        .toList();
  }

  static int _daysBetween(Date from, Date to) {
    final fromDateTime = DateTime(from.year, from.month, from.day);
    final toDateTime = DateTime(to.year, to.month, to.day);
    return (fromDateTime.difference(toDateTime).inHours / 24).round();
  }
}
