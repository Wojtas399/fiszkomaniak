import 'package:fiszkomaniak/utils/time_utils.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('compare times, hour of time1 is higher', () {
    const time1 = material.TimeOfDay(hour: 2, minute: 1);
    const time2 = material.TimeOfDay(hour: 1, minute: 1);

    final int result = TimeUtils.compareTimes(time1, time2);

    expect(result, 1);
  });

  test('compare times, hour of time2 is higher', () {
    const time1 = material.TimeOfDay(hour: 1, minute: 1);
    const time2 = material.TimeOfDay(hour: 2, minute: 1);

    final int result = TimeUtils.compareTimes(time1, time2);

    expect(result, -1);
  });

  test('compare times, hours equal, minute of time1 is higher', () {
    const time1 = material.TimeOfDay(hour: 2, minute: 2);
    const time2 = material.TimeOfDay(hour: 2, minute: 1);

    final int result = TimeUtils.compareTimes(time1, time2);

    expect(result, 1);
  });

  test('compare times, hours equal, minute of time2 is higher', () {
    const time1 = material.TimeOfDay(hour: 2, minute: 1);
    const time2 = material.TimeOfDay(hour: 2, minute: 2);

    final int result = TimeUtils.compareTimes(time1, time2);

    expect(result, -1);
  });

  test('compare times, hours equal, minutes equal', () {
    const material.TimeOfDay time1 = material.TimeOfDay(hour: 2, minute: 2);
    const material.TimeOfDay time2 = material.TimeOfDay(hour: 2, minute: 2);

    final int result = TimeUtils.compareTimes(time1, time2);

    expect(result, 0);
  });

  test('is past time, past date', () {
    const time = material.TimeOfDay(hour: 10, minute: 20);
    final date = DateTime(2022, 1, 1);

    final bool isPastTime = TimeUtils.isPastTime(time, date);

    expect(isPastTime, true);
  });

  test('is past time, current date, past time', () {
    final time = material.TimeOfDay.now().subtract(hours: 1);
    final date = DateTime.now();

    final bool isPastTime = TimeUtils.isPastTime(time, date);

    expect(isPastTime, true);
  });

  test('is past time, time from the future', () {
    final time = material.TimeOfDay.now().add(hours: 1);
    final date = DateTime.now().add(const Duration(days: 1));

    final bool isPastTime = TimeUtils.isPastTime(time, date);

    expect(isPastTime, false);
  });

  test('is time 1 earlier than time 2, true', () {
    const time1 = material.TimeOfDay(hour: 10, minute: 0);
    const time2 = material.TimeOfDay(hour: 11, minute: 0);

    final bool result = TimeUtils.isTime1EarlierThanTime2(
      time1: time1,
      time2: time2,
    );

    expect(result, true);
  });

  test('is time 1 earlier than time 2, false', () {
    const time1 = material.TimeOfDay(hour: 10, minute: 0);
    const time2 = material.TimeOfDay(hour: 9, minute: 0);

    final bool result = TimeUtils.isTime1EarlierThanTime2(
      time1: time1,
      time2: time2,
    );

    expect(result, false);
  });
}

extension TimeOfDayExtension on material.TimeOfDay {
  material.TimeOfDay add({int hours = 0, int minutes = 0}) {
    return replacing(hour: hour + hours, minute: minute + minutes);
  }

  material.TimeOfDay subtract({int hours = 0, int minutes = 0}) {
    return replacing(hour: hour - hours, minute: minute - minutes);
  }
}
