import '../models/settings/appearance_settings_model.dart';
import '../models/settings/notifications_settings_model.dart';

abstract class SettingsInterface {
  Future<void> setDefaultSettings();

  Future<void> saveAppearanceSettings({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    bool? isSessionTimerInvisibilityOn,
  });

  Future<void> saveNotificationsSettings({
    bool? areSessionsPlannedNotificationsOn,
    bool? areSessionsDefaultNotificationsOn,
    bool? areAchievementsNotificationsOn,
    bool? areLossOfDaysNotificationsOn,
  });

  Future<AppearanceSettings> loadAppearanceSettings();

  Future<NotificationsSettings> loadNotificationsSettings();
}
