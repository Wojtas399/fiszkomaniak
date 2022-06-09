import 'package:fiszkomaniak/firebase/models/appearance_settings_db_model.dart';
import 'package:fiszkomaniak/firebase/models/notifications_settings_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_settings_service.dart';
import 'package:fiszkomaniak/interfaces/settings_interface.dart';
import 'package:fiszkomaniak/models/settings/appearance_settings_model.dart';
import 'package:fiszkomaniak/models/settings/notifications_settings_model.dart';

class SettingsRepository implements SettingsInterface {
  late final FireSettingsService _fireSettingsService;

  SettingsRepository({required FireSettingsService fireSettingsService}) {
    _fireSettingsService = fireSettingsService;
  }

  @override
  Future<void> setDefaultUserSettings() async {
    await _fireSettingsService.setDefaultSettings();
  }

  @override
  Future<AppearanceSettings> loadAppearanceSettings() async {
    final AppearanceSettingsDbModel settings =
        await _fireSettingsService.loadAppearanceSettings();
    final bool? isDarkModeOn = settings.isDarkModeOn;
    final bool? isDarkModeCompatibilityWithSystemOn =
        settings.isDarkModeCompatibilityWithSystemOn;
    final bool? isSessionTimerInvisibilityOn =
        settings.isSessionTimerInvisibilityOn;
    if (isDarkModeOn != null &&
        isDarkModeCompatibilityWithSystemOn != null &&
        isSessionTimerInvisibilityOn != null) {
      return AppearanceSettings(
        isDarkModeOn: isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            isDarkModeCompatibilityWithSystemOn,
        isSessionTimerInvisibilityOn: isSessionTimerInvisibilityOn,
      );
    } else {
      throw 'Cannot load one of the appearance settings.';
    }
  }

  @override
  Future<NotificationsSettings> loadNotificationsSettings() async {
    final NotificationsSettingsDbModel settings =
        await _fireSettingsService.loadNotificationsSettings();
    final bool? areSessionsPlannedNotificationsOn =
        settings.areSessionsPlannedNotificationsOn;
    final bool? areSessionsDefaultNotificationsOn =
        settings.areSessionsDefaultNotificationsOn;
    final bool? areAchievementsNotificationsOn =
        settings.areAchievementsNotificationsOn;
    final bool? areLossOfDaysNotificationsOn =
        settings.areLossOfDaysNotificationsOn;
    if (areSessionsPlannedNotificationsOn != null &&
        areSessionsDefaultNotificationsOn != null &&
        areAchievementsNotificationsOn != null &&
        areLossOfDaysNotificationsOn != null) {
      return NotificationsSettings(
        areSessionsPlannedNotificationsOn: areSessionsPlannedNotificationsOn,
        areSessionsDefaultNotificationsOn: areSessionsDefaultNotificationsOn,
        areAchievementsNotificationsOn: areAchievementsNotificationsOn,
        areDaysStreakLoseNotificationsOn: areLossOfDaysNotificationsOn,
      );
    } else {
      throw 'Cannot load one of the notifications settings.';
    }
  }

  @override
  Future<void> updateAppearanceSettings({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    bool? isSessionTimerInvisibilityOn,
  }) async {
    await _fireSettingsService.updateAppearanceSettings(
      isDarkModeOn: isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
      isSessionTimerInvisibilityOn: isSessionTimerInvisibilityOn,
    );
  }

  @override
  Future<void> updateNotificationsSettings({
    bool? areSessionsPlannedNotificationsOn,
    bool? areSessionsDefaultNotificationsOn,
    bool? areAchievementsNotificationsOn,
    bool? areLossOfDaysNotificationsOn,
  }) async {
    await _fireSettingsService.updateNotificationsSettings(
      areSessionsPlannedNotificationsOn: areSessionsPlannedNotificationsOn,
      areSessionsDefaultNotificationsOn: areSessionsDefaultNotificationsOn,
      areAchievementsNotificationsOn: areAchievementsNotificationsOn,
      areLossOfDaysNotificationsOn: areLossOfDaysNotificationsOn,
    );
  }
}
