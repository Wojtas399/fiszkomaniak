import 'package:fiszkomaniak/utils/date_utils.dart';
import 'package:flutter/material.dart' as material;
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

  test('compare times, hour of time1 is higher', () {
    const material.TimeOfDay time1 = material.TimeOfDay(hour: 2, minute: 1);
    const material.TimeOfDay time2 = material.TimeOfDay(hour: 1, minute: 1);

    final int result = DateUtils.compareTimes(time1, time2);

    expect(result, 1);
  });

  test('compare times, hour of time2 is higher', () {
    const material.TimeOfDay time1 = material.TimeOfDay(hour: 1, minute: 1);
    const material.TimeOfDay time2 = material.TimeOfDay(hour: 2, minute: 1);

    final int result = DateUtils.compareTimes(time1, time2);

    expect(result, -1);
  });

  test('compare times, hours equal, minute of time1 is higher', () {
    const material.TimeOfDay time1 = material.TimeOfDay(hour: 2, minute: 2);
    const material.TimeOfDay time2 = material.TimeOfDay(hour: 2, minute: 1);

    final int result = DateUtils.compareTimes(time1, time2);

    expect(result, 1);
  });

  test('compare times, hours equal, minute of time2 is higher', () {
    const material.TimeOfDay time1 = material.TimeOfDay(hour: 2, minute: 1);
    const material.TimeOfDay time2 = material.TimeOfDay(hour: 2, minute: 2);

    final int result = DateUtils.compareTimes(time1, time2);

    expect(result, -1);
  });

  test('compare times, hours equal, minutes equal', () {
    const material.TimeOfDay time1 = material.TimeOfDay(hour: 2, minute: 2);
    const material.TimeOfDay time2 = material.TimeOfDay(hour: 2, minute: 2);

    final int result = DateUtils.compareTimes(time1, time2);

    expect(result, 0);
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
}
