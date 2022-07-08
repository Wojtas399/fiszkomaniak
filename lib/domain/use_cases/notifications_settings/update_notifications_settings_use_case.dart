import 'package:fiszkomaniak/interfaces/notifications_settings_interface.dart';

class UpdateNotificationsSettingsUseCase {
  late final NotificationsSettingsInterface _notificationsSettingsInterface;

  UpdateNotificationsSettingsUseCase({
    required NotificationsSettingsInterface notificationsSettingsInterface,
  }) {
    _notificationsSettingsInterface = notificationsSettingsInterface;
  }

  Future<void> execute({
    bool? areSessionsPlannedNotificationsOn,
    bool? areSessionsDefaultNotificationsOn,
    bool? areAchievementsNotificationsOn,
    bool? areLossOfDaysStreakNotificationsOn,
  }) async {
    await _notificationsSettingsInterface.updateSettings(
      areSessionsPlannedNotificationsOn: areSessionsPlannedNotificationsOn,
      areSessionsDefaultNotificationsOn: areSessionsDefaultNotificationsOn,
      areAchievementsNotificationsOn: areAchievementsNotificationsOn,
      areLossOfDaysStreakNotificationsOn: areLossOfDaysStreakNotificationsOn,
    );
  }
}
