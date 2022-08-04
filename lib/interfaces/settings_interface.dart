import '../domain/entities/settings.dart';

abstract class SettingsInterface {
  Stream<Settings> get settings$;

  Stream<AppearanceSettings> get appearanceSettings$;

  Stream<NotificationsSettings> get notificationsSettings$;

  Future<void> setDefaultSettings();

  Future<void> loadSettings();

  Future<void> updateAppearanceSettings({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    bool? isSessionTimerInvisibilityOn,
  });

  Future<void> updateNotificationsSettings({
    bool? areSessionsScheduledNotificationsOn,
    bool? areSessionsDefaultNotificationsOn,
    bool? areAchievementsNotificationsOn,
    bool? areLossOfDaysStreakNotificationsOn,
  });

  void reset();
}
