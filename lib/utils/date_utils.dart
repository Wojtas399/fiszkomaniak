import 'package:flutter/material.dart';

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
}