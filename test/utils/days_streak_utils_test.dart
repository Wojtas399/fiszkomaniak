import 'package:flutter_test/flutter_test.dart';
import 'package:fiszkomaniak/domain/entities/day.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/utils/days_streak_utils.dart';

void main() {
  final utils = DaysStreakUtils();

  test(
    'get streak, should return days streak from today as default',
    () {
      final List<Day> days = [
        createDay(date: Date.now()),
        createDay(date: Date.now().subtractDays(1)),
        createDay(date: Date.now().subtractDays(2)),
      ];

      final int streak = utils.getStreak(days);

      expect(streak, 3);
    },
  );

  test(
    'get streak, should return days streak from yesterday if days streak from today is 0',
    () {
      final List<Day> days = [
        createDay(date: Date.now().subtractDays(1)),
        createDay(date: Date.now().subtractDays(2)),
      ];

      final int streak = utils.getStreak(days);

      expect(streak, 2);
    },
  );

  test(
    'get streak, should return 0 if there is no streak',
    () {
      final List<Day> days = [
        createDay(date: Date.now().subtractDays(2)),
        createDay(date: Date.now().subtractDays(3)),
        createDay(date: Date.now().subtractDays(5)),
      ];

      final int streak = utils.getStreak(days);

      expect(streak, 0);
    },
  );
}
