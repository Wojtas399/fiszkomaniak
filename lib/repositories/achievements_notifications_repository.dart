import 'package:fiszkomaniak/interfaces/achievements_notifications_interface.dart';
import 'package:fiszkomaniak/local_notifications/local_notifications_service.dart';
import 'package:fiszkomaniak/models/date_model.dart';

class AchievementsNotificationsRepository
    implements AchievementsNotificationsInterface {
  late final LocalNotificationsService _localNotificationsService;

  AchievementsNotificationsRepository({
    required LocalNotificationsService localNotificationsService,
  }) {
    _localNotificationsService = localNotificationsService;
  }

  @override
  Future<void> setDaysStreakLoseNotification({required Date date}) async {
    await _localNotificationsService.addNotification(
      id: 'daysStreakLose'.hashCode,
      body:
          'Masz jeszcze 5h na naukę, aby nie utracić liczby dni nauki z rzędu!',
      dateTime: DateTime(date.year, date.month, date.day, 19, 00),
      payload: 'daysStreakLose',
    );
  }

  @override
  Future<void> removeDaysStreakLoseNotification() async {
    await _localNotificationsService.cancelNotification(
      id: 'daysStreakLose'.hashCode,
    );
  }
}
