class DateUtils {
  static int compareDates(DateTime date1, DateTime date2) {
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

  static bool isPastDate(DateTime? date) {
    if (date == null) {
      return false;
    }
    return compareDates(date, DateTime.now()) == -1;
  }

  static bool isTodayDate(DateTime? date) {
    if (date == null) {
      return false;
    }
    return compareDates(date, DateTime.now()) == 0;
  }

  static List<DateTime> getDaysInARow(
    DateTime fromDate,
    List<DateTime> dates,
  ) {
    final List<DateTime> days = [];
    int daysInARow = 0;
    int counter = 0;
    final List<DateTime> sortedDates = [...dates];
    sortedDates.sort();
    final List<DateTime> datesInDescendingOrder = sortedDates.reversed.toList();
    while (counter < datesInDescendingOrder.length &&
        _daysBetween(
              fromDate,
              datesInDescendingOrder[counter],
            ) ==
            daysInARow) {
      days.add(datesInDescendingOrder[counter]);
      daysInARow++;
      counter++;
    }
    return days;
  }

  static List<DateTime> getDaysFromWeek(DateTime dayFromWeek) {
    DateTime firstDayOfWeek = dayFromWeek.subtract(
      Duration(days: dayFromWeek.weekday - 1),
    );
    firstDayOfWeek = DateTime(
      firstDayOfWeek.year,
      firstDayOfWeek.month,
      firstDayOfWeek.day,
    );
    return List<DateTime>.generate(
      7,
      (index) => firstDayOfWeek.add(Duration(days: index)),
    );
  }

  static int _daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (from.difference(to).inHours / 24).round();
  }
}
