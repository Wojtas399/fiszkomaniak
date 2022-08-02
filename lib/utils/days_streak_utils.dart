import '../domain/entities/day.dart';
import '../models/date_model.dart';
import 'date_utils.dart';

class DaysStreakUtils {
  int getStreak(List<Day>? days) {
    int daysStreak = 0;
    final List<Date>? dates = days?.map((day) => day.date).toList();
    if (dates != null) {
      daysStreak = DateUtils.getDaysInARow(Date.now(), dates).length;
      if (daysStreak == 0) {
        daysStreak = DateUtils.getDaysInARow(
          Date.now().subtractDays(1),
          dates,
        ).length;
      }
    }
    return daysStreak;
  }
}
