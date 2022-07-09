import 'package:fiszkomaniak/domain/entities/appearance_settings.dart';
import 'package:fiszkomaniak/firebase/models/appearance_settings_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_appearance_settings_service.dart';
import 'package:fiszkomaniak/interfaces/appearance_settings_interface.dart';
import 'package:rxdart/rxdart.dart';

class AppearanceSettingsRepository implements AppearanceSettingsInterface {
  late final FireAppearanceSettingsService _fireAppearanceSettingsService;
  final _appearanceSettings$ = BehaviorSubject<AppearanceSettings>.seeded(
    const AppearanceSettings(
      isDarkModeOn: false,
      isDarkModeCompatibilityWithSystemOn: false,
      isSessionTimerInvisibilityOn: true,
    ),
  );

  AppearanceSettingsRepository({
    required FireAppearanceSettingsService fireAppearanceSettingsService,
  }) {
    _fireAppearanceSettingsService = fireAppearanceSettingsService;
  }

  @override
  Stream<AppearanceSettings> get appearanceSettings$ =>
      _appearanceSettings$.stream;

  @override
  Future<void> setDefaultSettings() async {
    await _fireAppearanceSettingsService.setDefaultSettings();
  }

  @override
  Future<void> loadSettings() async {
    final settings = await _fireAppearanceSettingsService.loadSettings();
    _appearanceSettings$.add(
      _convertAppearanceSettingsDbModelToAppearanceSettings(settings),
    );
  }

  @override
  Future<void> updateSettings({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    bool? isSessionTimerInvisibilityOn,
  }) async {
    final AppearanceSettings currentSettings = _appearanceSettings$.value;
    try {
      _appearanceSettings$.add(currentSettings.copyWith(
        isDarkModeOn: isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            isDarkModeCompatibilityWithSystemOn,
        isSessionTimerInvisibilityOn: isSessionTimerInvisibilityOn,
      ));
      await _fireAppearanceSettingsService.updateSettings(
        isDarkModeOn: isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            isDarkModeCompatibilityWithSystemOn,
        isSessionTimerInvisibilityOn: isSessionTimerInvisibilityOn,
      );
    } catch (_) {
      _appearanceSettings$.add(currentSettings);
    }
  }

  AppearanceSettings _convertAppearanceSettingsDbModelToAppearanceSettings(
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
}
