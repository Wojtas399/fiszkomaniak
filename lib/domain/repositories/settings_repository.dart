import 'package:rxdart/rxdart.dart';
import '../../firebase/models/appearance_settings_db_model.dart';
import '../../firebase/models/notifications_settings_db_model.dart';
import '../../firebase/services/fire_appearance_settings_service.dart';
import '../../firebase/services/fire_notifications_settings_service.dart';
import '../../interfaces/settings_interface.dart';
import '../entities/settings.dart';

class SettingsRepository implements SettingsInterface {
  late final FireAppearanceSettingsService _fireAppearanceSettingsService;
  late final FireNotificationsSettingsService _fireNotificationsSettingsService;
  late final BehaviorSubject<Settings> _settings$;

  SettingsRepository({
    required FireAppearanceSettingsService fireAppearanceSettingsService,
    required FireNotificationsSettingsService fireNotificationsSettingsService,
  }) {
    _fireAppearanceSettingsService = fireAppearanceSettingsService;
    _fireNotificationsSettingsService = fireNotificationsSettingsService;
    _settings$ = BehaviorSubject<Settings>.seeded(_createInitialSettings());
  }

  @override
  Stream<Settings> get settings$ => _settings$.stream;

  @override
  Stream<AppearanceSettings> get appearanceSettings$ => settings$.map(
        (Settings settings) => settings.appearanceSettings,
      );

  @override
  Stream<NotificationsSettings> get notificationsSettings$ => settings$.map(
        (Settings settings) => settings.notificationsSettings,
      );

  @override
  Future<void> setDefaultSettings() async {
    await _fireAppearanceSettingsService.setDefaultSettings();
    await _fireNotificationsSettingsService.setDefaultSettings();
  }

  @override
  Future<void> loadSettings() async {
    final AppearanceSettingsDbModel? dbAppearanceSettings =
        await _fireAppearanceSettingsService.loadSettings();
    final NotificationsSettingsDbModel? dbNotificationsSettings =
        await _fireNotificationsSettingsService.loadSettings();
    _settings$.add(
      Settings(
        appearanceSettings: _convertDbAppearanceSettingsToAppearanceSettings(
          dbAppearanceSettings,
        ),
        notificationsSettings:
            _convertDbNotificationsSettingsToNotificationsSettings(
          dbNotificationsSettings,
        ),
      ),
    );
  }

  @override
  Future<void> updateAppearanceSettings({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    bool? isSessionTimerInvisibilityOn,
  }) async {
    final Settings currentSettings = _settings$.value;
    try {
      _settings$.add(
        currentSettings.copyWith(
          appearanceSettings: currentSettings.appearanceSettings.copyWith(
            isDarkModeOn: isDarkModeOn,
            isDarkModeCompatibilityWithSystemOn:
                isDarkModeCompatibilityWithSystemOn,
            isSessionTimerInvisibilityOn: isSessionTimerInvisibilityOn,
          ),
        ),
      );
      await _fireAppearanceSettingsService.updateSettings(
        isDarkModeOn: isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            isDarkModeCompatibilityWithSystemOn,
        isSessionTimerInvisibilityOn: isSessionTimerInvisibilityOn,
      );
    } catch (_) {
      _settings$.add(currentSettings);
    }
  }

  @override
  Future<void> updateNotificationsSettings({
    bool? areSessionsScheduledNotificationsOn,
    bool? areSessionsDefaultNotificationsOn,
    bool? areAchievementsNotificationsOn,
    bool? areLossOfDaysStreakNotificationsOn,
  }) async {
    final Settings currentSettings = _settings$.value;
    try {
      _settings$.add(
        currentSettings.copyWith(
          notificationsSettings: currentSettings.notificationsSettings.copyWith(
            areSessionsScheduledNotificationsOn:
                areSessionsScheduledNotificationsOn,
            areSessionsDefaultNotificationsOn:
                areSessionsDefaultNotificationsOn,
            areAchievementsNotificationsOn: areAchievementsNotificationsOn,
            areLossOfDaysStreakNotificationsOn:
                areLossOfDaysStreakNotificationsOn,
          ),
        ),
      );
      await _fireNotificationsSettingsService.updateSettings(
        areSessionsScheduledNotificationsOn: areSessionsScheduledNotificationsOn,
        areSessionsDefaultNotificationsOn: areSessionsDefaultNotificationsOn,
        areAchievementsNotificationsOn: areAchievementsNotificationsOn,
        areLossOfDaysNotificationsOn: areLossOfDaysStreakNotificationsOn,
      );
    } catch (_) {
      _settings$.add(currentSettings);
    }
  }

  @override
  void reset() {
    _settings$.add(_createInitialSettings());
  }

  Settings _createInitialSettings() {
    return const Settings(
      appearanceSettings: AppearanceSettings(
        isDarkModeOn: false,
        isDarkModeCompatibilityWithSystemOn: false,
        isSessionTimerInvisibilityOn: false,
      ),
      notificationsSettings: NotificationsSettings(
        areSessionsScheduledNotificationsOn: true,
        areSessionsDefaultNotificationsOn: true,
        areAchievementsNotificationsOn: true,
        areLossOfDaysStreakNotificationsOn: true,
      ),
    );
  }

  AppearanceSettings _convertDbAppearanceSettingsToAppearanceSettings(
    AppearanceSettingsDbModel? dbAppearanceSettings,
  ) {
    final bool? isDarkModeOn = dbAppearanceSettings?.isDarkModeOn;
    final bool? isDarkModeCompatibilityWithSystemOn =
        dbAppearanceSettings?.isDarkModeCompatibilityWithSystemOn;
    final bool? isSessionTimerInvisibilityOn =
        dbAppearanceSettings?.isSessionTimerInvisibilityOn;
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
      throw 'Cannot load one of the appearance settings params';
    }
  }

  NotificationsSettings _convertDbNotificationsSettingsToNotificationsSettings(
    NotificationsSettingsDbModel? dbNotificationsSettings,
  ) {
    final bool? areSessionsPlannedNotificationsOn =
        dbNotificationsSettings?.areSessionsScheduledNotificationsOn;
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
        areSessionsScheduledNotificationsOn: areSessionsPlannedNotificationsOn,
        areSessionsDefaultNotificationsOn: areSessionsDefaultNotificationsOn,
        areAchievementsNotificationsOn: areAchievementsNotificationsOn,
        areLossOfDaysStreakNotificationsOn: areLossOfDaysNotificationsOn,
      );
    } else {
      throw 'Cannot load one of the notifications settings params';
    }
  }
}
