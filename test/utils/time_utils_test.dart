import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/time_model.dart';
import 'package:fiszkomaniak/utils/time_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('compare times, hour of time1 is higher', () {
    final Time time1 = createTime(hour: 2, minute: 1);
    final Time time2 = createTime(hour: 1, minute: 1);

    final int result = TimeUtils.compareTimes(time1, time2);

    expect(result, 1);
  });

  test('compare times, hour of time2 is higher', () {
    final Time time1 = createTime(hour: 1, minute: 1);
    final Time time2 = createTime(hour: 2, minute: 1);

    final int result = TimeUtils.compareTimes(time1, time2);

    expect(result, -1);
  });

  test('compare times, hours equal, minute of time1 is higher', () {
    final Time time1 = createTime(hour: 2, minute: 2);
    final Time time2 = createTime(hour: 2, minute: 1);

    final int result = TimeUtils.compareTimes(time1, time2);

    expect(result, 1);
  });

  test('compare times, hours equal, minute of time2 is higher', () {
    final Time time1 = createTime(hour: 2, minute: 1);
    final Time time2 = createTime(hour: 2, minute: 2);

    final int result = TimeUtils.compareTimes(time1, time2);

    expect(result, -1);
  });

  test('compare times, hours equal, minutes equal', () {
    final Time time1 = createTime(hour: 2, minute: 2);
    final Time time2 = createTime(hour: 2, minute: 2);

    final int result = TimeUtils.compareTimes(time1, time2);

    expect(result, 0);
  });

  test('is past time, past date', () {
    final Time time = createTime(hour: 10, minute: 20);
    final Date date = createDate(year: 2022, month: 1, day: 1);

    final bool isPastTime = TimeUtils.isPastTime(time, date);

    expect(isPastTime, true);
  });

  test('is past time, current date, past time', () {
    final Time time = Time.now().subtractMinutes(10);
    final Date date = Date.now();

    final bool isPastTime = TimeUtils.isPastTime(time, date);

    expect(isPastTime, true);
  });

  test('is past time, time from the future', () {
    final Time time = Time.now().addMinutes(70);
    final Date date = Date.now().addDays(2);

    final bool isPastTime = TimeUtils.isPastTime(time, date);

    expect(isPastTime, false);
  });

  test('is now, true', () {
    final Time time = Time.now();
    final Date date = Date.now();

    final bool result = TimeUtils.isNow(time, date);

    expect(result, true);
  });

  test('is now, false', () {
    final Time time = Time.now().addMinutes(30);
    final Date date = Date.now();

    final bool result = TimeUtils.isNow(time, date);

    expect(result, false);
  });

  test('is time 1 earlier than time 2, true', () {
    final Time time1 = createTime(hour: 10, minute: 0);
    final Time time2 = createTime(hour: 11, minute: 0);

    final bool result = TimeUtils.isTime1EarlierThanTime2(
      time1: time1,
      time2: time2,
    );

    expect(result, true);
  });

  test('is time 1 earlier than time 2, false', () {
    final Time time1 = createTime(hour: 10, minute: 0);
    final Time time2 = createTime(hour: 9, minute: 0);

    final bool result = TimeUtils.isTime1EarlierThanTime2(
      time1: time1,
      time2: time2,
    );

    expect(result, false);
  });
}
