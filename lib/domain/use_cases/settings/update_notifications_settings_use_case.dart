import '../../../interfaces/settings_interface.dart';

class UpdateNotificationsSettingsUseCase {
  late final SettingsInterface _settingsInterface;

  UpdateNotificationsSettingsUseCase({
    required SettingsInterface settingsInterface,
  }) {
    _settingsInterface = settingsInterface;
  }

  Future<void> execute({
    bool? areSessionsScheduledNotificationsOn,
    bool? areSessionsDefaultNotificationsOn,
    bool? areAchievementsNotificationsOn,
    bool? areLossOfDaysStreakNotificationsOn,
  }) async {
    await _settingsInterface.updateNotificationsSettings(
      areSessionsScheduledNotificationsOn: areSessionsScheduledNotificationsOn,
      areSessionsDefaultNotificationsOn: areSessionsDefaultNotificationsOn,
      areAchievementsNotificationsOn: areAchievementsNotificationsOn,
      areLossOfDaysStreakNotificationsOn: areLossOfDaysStreakNotificationsOn,
    );
  }
}
