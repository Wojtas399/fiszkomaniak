import '../domain/entities/day.dart';
import '../models/date_model.dart';
import 'date_utils.dart';

class DaysStreakUtils {
  final DateUtils _dateUtils = DateUtils();

  int getStreak(List<Day>? days) {
    int daysStreak = 0;
    final List<Date>? dates = days?.map((day) => day.date).toList();
    if (dates != null) {
      daysStreak = _dateUtils.getDaysInARow(Date.now(), dates).length;
      if (daysStreak == 0) {
        daysStreak = _dateUtils.getDaysInARow(
          Date.now().subtractDays(1),
          dates,
        ).length;
      }
    }
    return daysStreak;
  }
}
