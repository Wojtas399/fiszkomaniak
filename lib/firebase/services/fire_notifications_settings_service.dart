import 'package:fiszkomaniak/firebase/fire_references.dart';
import 'package:fiszkomaniak/firebase/models/notifications_settings_db_model.dart';

class FireNotificationsSettingsService {
  Future<void> setDefaultSettings() async {
    await FireReferences.notificationsSettingsRefWithConverter.set(
      NotificationsSettingsDbModel(
        areSessionsPlannedNotificationsOn: true,
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
    bool? areSessionsPlannedNotificationsOn,
    bool? areSessionsDefaultNotificationsOn,
    bool? areAchievementsNotificationsOn,
    bool? areLossOfDaysNotificationsOn,
  }) async {
    await FireReferences.notificationsSettingsRefWithConverter.update(
      NotificationsSettingsDbModel(
        areSessionsPlannedNotificationsOn: areSessionsPlannedNotificationsOn,
        areSessionsDefaultNotificationsOn: areSessionsDefaultNotificationsOn,
        areAchievementsNotificationsOn: areAchievementsNotificationsOn,
        areLossOfDaysNotificationsOn: areLossOfDaysNotificationsOn,
      ).toJson(),
    );
  }
}
