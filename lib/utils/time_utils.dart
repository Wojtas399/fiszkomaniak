import 'package:fiszkomaniak/utils/date_utils.dart' as custom_date_utils;
import 'package:flutter/material.dart';

class TimeUtils {
  static int compareTimes(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour == time2.hour) {
      if (time1.minute == time2.minute) {
        return 0;
      } else {
        return time1.minute > time2.minute ? 1 : -1;
      }
    } else {
      return time1.hour > time2.hour ? 1 : -1;
    }
  }

  static bool isPastTime(TimeOfDay time, DateTime date) {
    return custom_date_utils.DateUtils.isPastDate(date) ||
        custom_date_utils.DateUtils.isTodayDate(date) &&
            isTime1EarlierThanTime2(
              time1: time,
              time2: TimeOfDay.now(),
            );
  }

  static bool isTime1EarlierThanTime2({
    required TimeOfDay time1,
    required TimeOfDay time2,
  }) {
    return compareTimes(time1, time2) == -1;
  }
}
