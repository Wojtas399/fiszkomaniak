import 'package:fiszkomaniak/firebase/fire_references.dart';
import 'package:fiszkomaniak/firebase/models/appearance_settings_db_model.dart';
import 'package:fiszkomaniak/firebase/models/notifications_settings_db_model.dart';

class FireSettingsService {
  Future<void> setDefaultSettings() async {
    try {
      FireReferences.appearanceSettingsRef.set(
        AppearanceSettingsDbModel(
          isDarkModeOn: false,
          isDarkModeCompatibilityWithSystemOn: false,
          isSessionTimerInvisibilityOn: false,
        ),
      );
      FireReferences.notificationsSettingsRef.set(
        NotificationsSettingsDbModel(
          areSessionsPlannedNotificationsOn: true,
          areSessionsDefaultNotificationsOn: true,
          areAchievementsNotificationsOn: true,
          areLossOfDaysNotificationsOn: true,
        ),
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<AppearanceSettingsDbModel> loadAppearanceSettings() async {
    try {
      final settings =
          await FireReferences.appearanceSettingsRefWithConverter.get();
      final settingsData = settings.data();
      if (settingsData != null) {
        return settingsData;
      } else {
        throw 'Cannot find appearance settings for this user.';
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<NotificationsSettingsDbModel> loadNotificationsSettings() async {
    try {
      final settings =
          await FireReferences.notificationsSettingsRefWithConverter.get();
      final settingsData = settings.data();
      if (settingsData != null) {
        return settingsData;
      } else {
        throw 'Cannot find notifications settings for this user.';
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateAppearanceSettings({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    bool? isSessionTimerInvisibilityOn,
  }) async {
    try {
      FireReferences.appearanceSettingsRef.update(
        AppearanceSettingsDbModel(
          isDarkModeOn: isDarkModeOn,
          isDarkModeCompatibilityWithSystemOn:
              isDarkModeCompatibilityWithSystemOn,
          isSessionTimerInvisibilityOn: isSessionTimerInvisibilityOn,
        ).toJson(),
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateNotificationsSettings({
    bool? areSessionsPlannedNotificationsOn,
    bool? areSessionsDefaultNotificationsOn,
    bool? areAchievementsNotificationsOn,
    bool? areLossOfDaysNotificationsOn,
  }) async {
    try {
      FireReferences.notificationsSettingsRef.update(
        NotificationsSettingsDbModel(
          areSessionsPlannedNotificationsOn: areSessionsPlannedNotificationsOn,
          areSessionsDefaultNotificationsOn: areSessionsDefaultNotificationsOn,
          areAchievementsNotificationsOn: areAchievementsNotificationsOn,
          areLossOfDaysNotificationsOn: areLossOfDaysNotificationsOn,
        ).toJson(),
      );
    } catch (error) {
      rethrow;
    }
  }
}
