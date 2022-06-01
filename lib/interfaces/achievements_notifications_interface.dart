import 'package:fiszkomaniak/models/date_model.dart';

abstract class AchievementsNotificationsInterface {
  Future<void> setDaysStreakLoseNotification({required Date date});

  Future<void> removeDaysStreakLoseNotification();
}
