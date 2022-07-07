import 'package:fiszkomaniak/firebase/services/fire_notifications_settings_service.dart';
import 'package:fiszkomaniak/interfaces/notifications_settings_interface.dart';
import 'package:fiszkomaniak/domain/entities/notifications_settings.dart';
import 'package:rxdart/rxdart.dart';

class NotificationsSettingsRepository
    implements NotificationsSettingsInterface {
  late final FireNotificationsSettingsService _fireNotificationsSettingsService;
  final _notificationsSettings$ = BehaviorSubject<NotificationsSettings>();

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
      _notificationsSettings$.add(
        NotificationsSettings(
          areSessionsPlannedNotificationsOn: areSessionsPlannedNotificationsOn,
          areSessionsDefaultNotificationsOn: areSessionsDefaultNotificationsOn,
          areAchievementsNotificationsOn: areAchievementsNotificationsOn,
          areDaysStreakLoseNotificationsOn: areLossOfDaysNotificationsOn,
        ),
      );
    } else {
      throw 'Cannot load one of the notifications settings.';
    }
  }

  @override
  Future<void> updateSettings({
    bool? areSessionsPlannedNotificationsOn,
    bool? areSessionsDefaultNotificationsOn,
    bool? areAchievementsNotificationsOn,
    bool? areLossOfDaysNotificationsOn,
  }) async {
    await _fireNotificationsSettingsService.updateSettings(
      areSessionsPlannedNotificationsOn: areSessionsPlannedNotificationsOn,
      areSessionsDefaultNotificationsOn: areSessionsDefaultNotificationsOn,
      areAchievementsNotificationsOn: areAchievementsNotificationsOn,
      areLossOfDaysNotificationsOn: areLossOfDaysNotificationsOn,
    );
  }
}
