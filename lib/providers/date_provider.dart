import '../models/time_model.dart';
import '../models/date_model.dart';
import '../utils/time_utils.dart';

class DateProvider {
  final TimeUtils _timeUtils = TimeUtils();

  Date getNow() {
    return Date.now();
  }

  Date getTomorrowDate() {
    return Date.now().addDays(1);
  }

  bool isAfterNineteenToday() {
    return _timeUtils.isPastTime(
      const Time(hour: 19, minute: 00),
      Date.now(),
    );
  }
}
