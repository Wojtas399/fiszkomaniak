import 'package:fiszkomaniak/interfaces/notifications_settings_storage_interface.dart';
import 'package:fiszkomaniak/memory_storage/settings_storage_service.dart';
import 'package:fiszkomaniak/models/settings/notifications_settings_model.dart';

class NotificationsSettingsStorageRepository
    implements NotificationsSettingsStorageInterface {
  late final SettingsStorageService _settingsStorageService;

  NotificationsSettingsStorageRepository({
    required SettingsStorageService settingsStorageService,
  }) {
    _settingsStorageService = settingsStorageService;
  }

  @override
  Future<NotificationsSettings> load() async {
    Map<String, bool> notificationsSettings =
        await _settingsStorageService.loadSettings(
      [
        'areSessionsPlannedNotificationsOn',
        'areSessionsDefaultNotificationsOn',
        'areAchievementsNotificationsOn',
        'areLossOfDaysNotificationsOn'
      ],
    );
    return NotificationsSettings(
      areSessionsPlannedNotificationsOn:
          notificationsSettings['areSessionsPlannedNotificationsOn'] ?? false,
      areSessionsDefaultNotificationsOn:
          notificationsSettings['areSessionsDefaultNotificationsOn'] ?? false,
      areAchievementsNotificationsOn:
          notificationsSettings['areAchievementsNotificationsOn'] ?? false,
      areLossOfDaysNotificationsOn:
          notificationsSettings['areLossOfDaysNotificationsOn'] ?? false,
    );
  }

  @override
  Future<void> save({
    bool? areSessionsPlannedNotificationsOn,
    bool? areSessionsDefaultNotificationsOn,
    bool? areAchievementsNotificationsOn,
    bool? areLossOfDaysNotificationsOn,
  }) async {
    if (areSessionsPlannedNotificationsOn != null) {
      await _settingsStorageService.saveParameter(
        SettingsStorageBoolParameter(
          key: 'areSessionsPlannedNotificationsOn',
          value: areSessionsPlannedNotificationsOn,
        ),
      );
    }
    if (areSessionsDefaultNotificationsOn != null) {
      await _settingsStorageService.saveParameter(
        SettingsStorageBoolParameter(
          key: 'areSessionsDefaultNotificationsOn',
          value: areSessionsDefaultNotificationsOn,
        ),
      );
    }
    if (areAchievementsNotificationsOn != null) {
      await _settingsStorageService.saveParameter(
        SettingsStorageBoolParameter(
          key: 'areAchievementsNotificationsOn',
          value: areAchievementsNotificationsOn,
        ),
      );
    }
    if (areLossOfDaysNotificationsOn != null) {
      await _settingsStorageService.saveParameter(
        SettingsStorageBoolParameter(
          key: 'areLossOfDaysNotificationsOn',
          value: areLossOfDaysNotificationsOn,
        ),
      );
    }
  }
}
