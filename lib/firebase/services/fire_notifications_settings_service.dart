import '../models/notifications_settings_db_model.dart';
import '../fire_references.dart';

class FireNotificationsSettingsService {
  Future<void> setDefaultSettings() async {
    await FireReferences.notificationsSettingsRefWithConverter.set(
      NotificationsSettingsDbModel(
        areSessionsScheduledNotificationsOn: true,
        areSessionsDefaultNotificationsOn: true,
        areAchievementsNotificationsOn: true,
        areLossOfDaysNotificationsOn: true,
      ),
    );
  }

  Future<NotificationsSettingsDbModel?> loadSettings() async {
    final settings =
        await FireReferences.notificationsSettingsRefWithConverter.get();
    return settings.data();
  }

  Future<void> updateSettings({
    bool? areSessionsScheduledNotificationsOn,
    bool? areSessionsDefaultNotificationsOn,
    bool? areAchievementsNotificationsOn,
    bool? areLossOfDaysNotificationsOn,
  }) async {
    await FireReferences.notificationsSettingsRefWithConverter.update(
      NotificationsSettingsDbModel(
        areSessionsScheduledNotificationsOn: areSessionsScheduledNotificationsOn,
        areSessionsDefaultNotificationsOn: areSessionsDefaultNotificationsOn,
        areAchievementsNotificationsOn: areAchievementsNotificationsOn,
        areLossOfDaysNotificationsOn: areLossOfDaysNotificationsOn,
      ).toJson(),
    );
  }
}
