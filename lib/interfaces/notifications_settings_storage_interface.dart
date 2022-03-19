import 'package:fiszkomaniak/models/settings/notifications_settings_model.dart';

abstract class NotificationsSettingsStorageInterface {
  Future<void> save({
    bool? areSessionsPlannedNotificationsOn,
    bool? areSessionsDefaultNotificationsOn,
    bool? areAchievementsNotificationsOn,
    bool? areLossOfDaysNotificationsOn,
  });

  Future<NotificationsSettings> load();
}
