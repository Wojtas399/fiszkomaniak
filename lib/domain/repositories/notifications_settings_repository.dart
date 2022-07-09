import 'package:fiszkomaniak/firebase/models/notifications_settings_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_notifications_settings_service.dart';
import 'package:fiszkomaniak/interfaces/notifications_settings_interface.dart';
import 'package:fiszkomaniak/domain/entities/notifications_settings.dart';
import 'package:rxdart/rxdart.dart';

class NotificationsSettingsRepository
    implements NotificationsSettingsInterface {
  late final FireNotificationsSettingsService _fireNotificationsSettingsService;
  final _notificationsSettings$ = BehaviorSubject<NotificationsSettings>.seeded(
    const NotificationsSettings(
      areSessionsPlannedNotificationsOn: true,
      areSessionsDefaultNotificationsOn: true,
      areAchievementsNotificationsOn: true,
      areLossOfDaysStreakNotificationsOn: true,
    ),
  );

  NotificationsSettingsRepository({
    required FireNotificationsSettingsService fireNotificationsSettingsService,
  }) {
    _fireNotificationsSettingsService = fireNotificationsSettingsService;
  }

  @override
  Stream<NotificationsSettings> get notificationsSettings$ =>
      _notificationsSettings$.stream;

  @override
  Future<void> setDefaultSettings() async {
    await _fireNotificationsSettingsService.setDefaultSettings();
  }

  @override
  Future<void> loadSettings() async {
    final settings = await _fireNotificationsSettingsService.loadSettings();
    _notificationsSettings$.add(
      _convertNotificationsSettingsDbModelToNotificationsSettings(settings),
    );
  }

  @override
  Future<void> updateSettings({
    bool? areSessionsPlannedNotificationsOn,
    bool? areSessionsDefaultNotificationsOn,
    bool? areAchievementsNotificationsOn,
    bool? areLossOfDaysStreakNotificationsOn,
  }) async {
    final NotificationsSettings currentSettings = _notificationsSettings$.value;
    try {
      _notificationsSettings$.add(currentSettings.copyWith(
        areSessionsPlannedNotificationsOn: areSessionsPlannedNotificationsOn,
        areSessionsDefaultNotificationsOn: areSessionsDefaultNotificationsOn,
        areAchievementsNotificationsOn: areAchievementsNotificationsOn,
        areLossOfDaysStreakNotificationsOn: areLossOfDaysStreakNotificationsOn,
      ));
      await _fireNotificationsSettingsService.updateSettings(
        areSessionsPlannedNotificationsOn: areSessionsPlannedNotificationsOn,
        areSessionsDefaultNotificationsOn: areSessionsDefaultNotificationsOn,
        areAchievementsNotificationsOn: areAchievementsNotificationsOn,
        areLossOfDaysNotificationsOn: areLossOfDaysStreakNotificationsOn,
      );
    } catch (_) {
      _notificationsSettings$.add(currentSettings);
    }
  }

  NotificationsSettings
      _convertNotificationsSettingsDbModelToNotificationsSettings(
    NotificationsSettingsDbModel? dbNotificationsSettings,
  ) {
    final bool? areSessionsPlannedNotificationsOn =
        dbNotificationsSettings?.areSessionsPlannedNotificationsOn;
    final bool? areSessionsDefaultNotificationsOn =
        dbNotificationsSettings?.areSessionsDefaultNotificationsOn;
    final bool? areAchievementsNotificationsOn =
        dbNotificationsSettings?.areAchievementsNotificationsOn;
    final bool? areLossOfDaysNotificationsOn =
        dbNotificationsSettings?.areLossOfDaysNotificationsOn;
    if (areSessionsPlannedNotificationsOn != null &&
        areSessionsDefaultNotificationsOn != null &&
        areAchievementsNotificationsOn != null &&
        areLossOfDaysNotificationsOn != null) {
      return NotificationsSettings(
        areSessionsPlannedNotificationsOn: areSessionsPlannedNotificationsOn,
        areSessionsDefaultNotificationsOn: areSessionsDefaultNotificationsOn,
        areAchievementsNotificationsOn: areAchievementsNotificationsOn,
        areLossOfDaysStreakNotificationsOn: areLossOfDaysNotificationsOn,
      );
    } else {
      throw 'Cannot load one of the notifications settings params';
    }
  }
}
