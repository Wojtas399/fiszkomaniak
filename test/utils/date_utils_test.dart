import 'package:fiszkomaniak/utils/date_utils.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('compare dates', () {
    test('year of date1 is higher', () {
      final DateTime date1 = DateTime(2022, 1, 1);
      final DateTime date2 = DateTime(2021, 1, 1);

      final int result = DateUtils.compareDates(date1, date2);

      expect(result, 1);
    });

    test('year of date2 is higher', () {
      final DateTime date1 = DateTime(2021, 1, 1);
      final DateTime date2 = DateTime(2022, 1, 1);

      final int result = DateUtils.compareDates(date1, date2);

      expect(result, -1);
    });

    test('years equal, month of date1 is higher', () {
      final DateTime date1 = DateTime(2022, 2, 1);
      final DateTime date2 = DateTime(2022, 1, 1);

      final int result = DateUtils.compareDates(date1, date2);

      expect(result, 1);
    });

    test('years equal, month of date2 is higher', () {
      final DateTime date1 = DateTime(2022, 1, 1);
      final DateTime date2 = DateTime(2022, 2, 1);

      final int result = DateUtils.compareDates(date1, date2);

      expect(result, -1);
    });

    test('years equal, months equal, day of date1 is higher', () {
      final DateTime date1 = DateTime(2022, 2, 2);
      final DateTime date2 = DateTime(2022, 2, 1);

      final int result = DateUtils.compareDates(date1, date2);

      expect(result, 1);
    });

    test('years equal, months equal, day of date2 is higher', () {
      final DateTime date1 = DateTime(2022, 2, 1);
      final DateTime date2 = DateTime(2022, 2, 2);

      final int result = DateUtils.compareDates(date1, date2);

      expect(result, -1);
    });

    test('years equal, months equal, days equal', () {
      final DateTime date1 = DateTime(2022, 2, 2);
      final DateTime date2 = DateTime(2022, 2, 2);

      final int result = DateUtils.compareDates(date1, date2);

      expect(result, 0);
    });
  });

  group('compare times', () {
    test('hour of time1 is higher', () {
      const material.TimeOfDay time1 = material.TimeOfDay(hour: 2, minute: 1);
      const material.TimeOfDay time2 = material.TimeOfDay(hour: 1, minute: 1);

      final int result = DateUtils.compareTimes(time1, time2);

      expect(result, 1);
    });

    test('hour of time2 is higher', () {
      const material.TimeOfDay time1 = material.TimeOfDay(hour: 1, minute: 1);
      const material.TimeOfDay time2 = material.TimeOfDay(hour: 2, minute: 1);

      final int result = DateUtils.compareTimes(time1, time2);

      expect(result, -1);
    });

    test('hours equal, minute of time1 is higher', () {
      const material.TimeOfDay time1 = material.TimeOfDay(hour: 2, minute: 2);
      const material.TimeOfDay time2 = material.TimeOfDay(hour: 2, minute: 1);

      final int result = DateUtils.compareTimes(time1, time2);

      expect(result, 1);
    });

    test('hours equal, minute of time2 is higher', () {
      const material.TimeOfDay time1 = material.TimeOfDay(hour: 2, minute: 1);
      const material.TimeOfDay time2 = material.TimeOfDay(hour: 2, minute: 2);

      final int result = DateUtils.compareTimes(time1, time2);

      expect(result, -1);
    });

    test('hours equal, minutes equal', () {
      const material.TimeOfDay time1 = material.TimeOfDay(hour: 2, minute: 2);
      const material.TimeOfDay time2 = material.TimeOfDay(hour: 2, minute: 2);

      final int result = DateUtils.compareTimes(time1, time2);

      expect(result, 0);
    });
  });
}
