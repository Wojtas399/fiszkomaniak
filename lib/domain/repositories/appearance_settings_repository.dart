import 'package:fiszkomaniak/domain/entities/appearance_settings.dart';
import 'package:fiszkomaniak/firebase/services/fire_appearance_settings_service.dart';
import 'package:fiszkomaniak/interfaces/appearance_settings_interface.dart';
import 'package:rxdart/rxdart.dart';

class AppearanceSettingsRepository implements AppearanceSettingsInterface {
  late final FireAppearanceSettingsService _fireAppearanceSettingsService;
  final _appearanceSettings$ = BehaviorSubject<AppearanceSettings>();

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
    final bool? isDarkModeOn = settings.isDarkModeOn;
    final bool? isDarkModeCompatibilityWithSystemOn =
        settings.isDarkModeCompatibilityWithSystemOn;
    final bool? isSessionTimerInvisibilityOn =
        settings.isSessionTimerInvisibilityOn;
    if (isDarkModeOn != null &&
        isDarkModeCompatibilityWithSystemOn != null &&
        isSessionTimerInvisibilityOn != null) {
      _appearanceSettings$.add(
        AppearanceSettings(
          isDarkModeOn: isDarkModeOn,
          isDarkModeCompatibilityWithSystemOn:
              isDarkModeCompatibilityWithSystemOn,
          isSessionTimerInvisibilityOn: isSessionTimerInvisibilityOn,
        ),
      );
    } else {
      throw 'Cannot load one of the appearance settings.';
    }
  }

  @override
  Future<void> updateSettings({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    bool? isSessionTimerInvisibilityOn,
  }) async {
    await _fireAppearanceSettingsService.updateSettings(
      isDarkModeOn: isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
      isSessionTimerInvisibilityOn: isSessionTimerInvisibilityOn,
    );
  }
}
