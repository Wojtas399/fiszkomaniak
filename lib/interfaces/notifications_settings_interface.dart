import '../domain/entities/notifications_settings.dart';

abstract class NotificationsSettingsInterface {
  Stream<NotificationsSettings> get notificationsSettings$;

  Future<void> setDefaultSettings();

  Future<void> loadSettings();

  Future<void> updateSettings({
    bool? areSessionsPlannedNotificationsOn,
    bool? areSessionsDefaultNotificationsOn,
    bool? areAchievementsNotificationsOn,
    bool? areLossOfDaysStreakNotificationsOn,
  });
}
