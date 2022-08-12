import '../models/date_model.dart';
import '../models/time_model.dart';
import 'date_utils.dart';

class TimeUtils {
  int compareTimes(Time time1, Time time2) {
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

  bool isPastTime(Time time, Date date) {
    return DateUtils.isPastDate(date) ||
        DateUtils.isTodayDate(date) &&
            isTime1EarlierThanTime2(
              time1: time,
              time2: Time.now(),
            );
  }

  bool isNow(Time time, Date date) {
    return date == Date.now() && time == Time.now();
  }

  bool isTime1EarlierThanTime2({
    required Time time1,
    required Time time2,
  }) {
    return compareTimes(time1, time2) == -1;
  }
}
