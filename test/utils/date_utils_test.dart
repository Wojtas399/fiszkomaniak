import 'package:fiszkomaniak/utils/date_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('compare dates, year of date1 is higher', () {
    final DateTime date1 = DateTime(2022, 1, 1);
    final DateTime date2 = DateTime(2021, 1, 1);

    final int result = DateUtils.compareDates(date1, date2);

    expect(result, 1);
  });

  test('compare dates, year of date2 is higher', () {
    final DateTime date1 = DateTime(2021, 1, 1);
    final DateTime date2 = DateTime(2022, 1, 1);

    final int result = DateUtils.compareDates(date1, date2);

    expect(result, -1);
  });

  test('compare dates, years equal, month of date1 is higher', () {
    final DateTime date1 = DateTime(2022, 2, 1);
    final DateTime date2 = DateTime(2022, 1, 1);

    final int result = DateUtils.compareDates(date1, date2);

    expect(result, 1);
  });

  test('compare dates, years equal, month of date2 is higher', () {
    final DateTime date1 = DateTime(2022, 1, 1);
    final DateTime date2 = DateTime(2022, 2, 1);

    final int result = DateUtils.compareDates(date1, date2);

    expect(result, -1);
  });

  test('compare dates, years equal, months equal, day of date1 is higher', () {
    final DateTime date1 = DateTime(2022, 2, 2);
    final DateTime date2 = DateTime(2022, 2, 1);

    final int result = DateUtils.compareDates(date1, date2);

    expect(result, 1);
  });

  test('compare dates, years equal, months equal, day of date2 is higher', () {
    final DateTime date1 = DateTime(2022, 2, 1);
    final DateTime date2 = DateTime(2022, 2, 2);

    final int result = DateUtils.compareDates(date1, date2);

    expect(result, -1);
  });

  test('compare dates, years equal, months equal, days equal', () {
    final DateTime date1 = DateTime(2022, 2, 2);
    final DateTime date2 = DateTime(2022, 2, 2);

    final int result = DateUtils.compareDates(date1, date2);

    expect(result, 0);
  });

  test('is past date, date as null', () {
    const DateTime? date = null;

    final bool isPastDate = DateUtils.isPastDate(date);

    expect(isPastDate, false);
  });

  test('is past date, date from the past', () {
    final DateTime date = DateTime(2022, 1, 1);

    final bool isPastDate = DateUtils.isPastDate(date);

    expect(isPastDate, true);
  });

  test('is past date, date from the future', () {
    final DateTime date = DateTime.now().add(const Duration(days: 2));

    final bool isPastDate = DateUtils.isPastDate(date);

    expect(isPastDate, false);
  });

  test('is today date, date as null', () {
    const DateTime? date = null;

    final bool isTodayDate = DateUtils.isTodayDate(date);

    expect(isTodayDate, false);
  });

  test('is today date, today date', () {
    final DateTime date = DateTime.now();

    final bool isTodayDate = DateUtils.isTodayDate(date);

    expect(isTodayDate, true);
  });

  test('is today date, date from the past', () {
    final DateTime date = DateTime(2022, 1, 1);

    final bool isTodayDate = DateUtils.isTodayDate(date);

    expect(isTodayDate, false);
  });

  test('is today date, date from the future', () {
    final DateTime date = DateTime.now().add(const Duration(days: 2));

    final bool isTodayDate = DateUtils.isTodayDate(date);

    expect(isTodayDate, false);
  });

  test('get days in a row, only current day', () {
    final DateTime fromDate = DateTime(2022, 1, 10);
    final List<DateTime> dates = [
      DateTime(2022, 1, 10),
      DateTime(2022, 1, 8),
    ];

    final List<DateTime> days = DateUtils.getDaysInARow(fromDate, dates);

    expect(days, [dates[0]]);
  });

  test('get days in a row, 0 days', () {
    final DateTime fromDate = DateTime(2022, 1, 10);
    final List<DateTime> dates = [
      DateTime(2022, 1, 8),
      DateTime(2022, 1, 4),
    ];

    final List<DateTime> days = DateUtils.getDaysInARow(fromDate, dates);

    expect(days, []);
  });

  test('get days in a row, 5 days', () {
    final DateTime fromDate = DateTime(2022, 1, 10);
    final List<DateTime> dates = [
      DateTime(2022, 1, 6),
      DateTime(2022, 1, 9),
      DateTime(2022, 1, 10),
      DateTime(2022, 1, 7),
      DateTime(2022, 1, 8),
    ];

    final List<DateTime> days = DateUtils.getDaysInARow(fromDate, dates);

    expect(days, [
      dates[2],
      dates[1],
      dates[4],
      dates[3],
      dates[0],
    ]);
  });

  test('get days from week', () {
    final List<DateTime> daysFromWeek = DateUtils.getDaysFromWeek(
      DateTime(2022, 5, 14),
    );

    expect(daysFromWeek, [
      DateTime(2022, 5, 9),
      DateTime(2022, 5, 10),
      DateTime(2022, 5, 11),
      DateTime(2022, 5, 12),
      DateTime(2022, 5, 13),
      DateTime(2022, 5, 14),
      DateTime(2022, 5, 15),
    ]);
  });
}
