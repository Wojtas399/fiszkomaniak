import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/utils/date_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('compare dates, year of date1 is higher', () {
    final Date date1 = createDate(year: 2022);
    final Date date2 = createDate(year: 2021);

    final int result = DateUtils.compareDates(date1, date2);

    expect(result, 1);
  });

  test('compare dates, year of date2 is higher', () {
    final Date date1 = createDate(year: 2021);
    final Date date2 = createDate(year: 2022);

    final int result = DateUtils.compareDates(date1, date2);

    expect(result, -1);
  });

  test('compare dates, years equal, month of date1 is higher', () {
    final Date date1 = createDate(month: 2);
    final Date date2 = createDate(month: 1);

    final int result = DateUtils.compareDates(date1, date2);

    expect(result, 1);
  });

  test('compare dates, years equal, month of date2 is higher', () {
    final Date date1 = createDate(month: 1);
    final Date date2 = createDate(month: 2);

    final int result = DateUtils.compareDates(date1, date2);

    expect(result, -1);
  });

  test('compare dates, years equal, months equal, day of date1 is higher', () {
    final Date date1 = createDate(day: 2);
    final Date date2 = createDate(day: 1);

    final int result = DateUtils.compareDates(date1, date2);

    expect(result, 1);
  });

  test('compare dates, years equal, months equal, day of date2 is higher', () {
    final Date date1 = createDate(day: 1);
    final Date date2 = createDate(day: 2);

    final int result = DateUtils.compareDates(date1, date2);

    expect(result, -1);
  });

  test('compare dates, years equal, months equal, days equal', () {
    final Date date1 = createDate();
    final Date date2 = createDate();

    final int result = DateUtils.compareDates(date1, date2);

    expect(result, 0);
  });

  test('is past date, date as null', () {
    const Date? date = null;

    final bool isPastDate = DateUtils.isPastDate(date);

    expect(isPastDate, false);
  });

  test('is past date, date from the past', () {
    final Date date = createDate(year: 2022, month: 1, day: 1);

    final bool isPastDate = DateUtils.isPastDate(date);

    expect(isPastDate, true);
  });

  test('is past date, date from the future', () {
    final Date date = Date.now().addDays(4);

    final bool isPastDate = DateUtils.isPastDate(date);

    expect(isPastDate, false);
  });

  test('is today date, date as null', () {
    const Date? date = null;

    final bool isTodayDate = DateUtils.isTodayDate(date);

    expect(isTodayDate, false);
  });

  test('is today date, today date', () {
    final Date date = Date.now();

    final bool isTodayDate = DateUtils.isTodayDate(date);

    expect(isTodayDate, true);
  });

  test('is today date, date from the past', () {
    final Date date = createDate(year: 2022, month: 1, day: 1);

    final bool isTodayDate = DateUtils.isTodayDate(date);

    expect(isTodayDate, false);
  });

  test('is today date, date from the future', () {
    final Date date = Date.now().addDays(4);

    final bool isTodayDate = DateUtils.isTodayDate(date);

    expect(isTodayDate, false);
  });

  test('get days in a row, only current day', () {
    final Date fromDate = createDate(day: 10);
    final List<Date> dates = [
      createDate(day: 10),
      createDate(day: 8),
    ];

    final List<Date> days = DateUtils.getDaysInARow(fromDate, dates);

    expect(days, [dates[0]]);
  });

  test('get days in a row, 0 days', () {
    final Date fromDate = createDate(day: 10);
    final List<Date> dates = [
      createDate(day: 8),
      createDate(day: 4),
    ];

    final List<Date> days = DateUtils.getDaysInARow(fromDate, dates);

    expect(days, []);
  });

  test('get days in a row, 5 days', () {
    final Date fromDate = createDate(day: 10);
    final List<Date> dates = [
      createDate(day: 6),
      createDate(day: 9),
      createDate(day: 10),
      createDate(day: 7),
      createDate(day: 8),
    ];

    final List<Date> days = DateUtils.getDaysInARow(fromDate, dates);

    expect(days, [
      dates[2],
      dates[1],
      dates[4],
      dates[3],
      dates[0],
    ]);
  });

  test('get days from week', () {
    final List<Date> daysFromWeek = DateUtils.getDaysFromWeek(
      createDate(month: 5, day: 14),
    );

    expect(daysFromWeek, [
      createDate(month: 5, day: 9),
      createDate(month: 5, day: 10),
      createDate(month: 5, day: 11),
      createDate(month: 5, day: 12),
      createDate(month: 5, day: 13),
      createDate(month: 5, day: 14),
      createDate(month: 5, day: 15),
    ]);
  });
}
