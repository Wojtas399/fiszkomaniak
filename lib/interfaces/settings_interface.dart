import '../models/settings/appearance_settings_model.dart';
import '../models/settings/notifications_settings_model.dart';

abstract class SettingsInterface {
  Future<void> setDefaultSettings();

  Future<AppearanceSettings> loadAppearanceSettings();

  Future<NotificationsSettings> loadNotificationsSettings();

  Future<void> updateAppearanceSettings({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    bool? isSessionTimerInvisibilityOn,
  });

  Future<void> updateNotificationsSettings({
    bool? areSessionsPlannedNotificationsOn,
    bool? areSessionsDefaultNotificationsOn,
    bool? areAchievementsNotificationsOn,
    bool? areLossOfDaysNotificationsOn,
  });
}
