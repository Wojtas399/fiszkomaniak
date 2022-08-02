import '../domain/entities/appearance_settings.dart';

abstract class AppearanceSettingsInterface {
  Stream<AppearanceSettings> get appearanceSettings$;

  Future<void> setDefaultSettings();

  Future<void> loadSettings();

  Future<void> updateSettings({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    bool? isSessionTimerInvisibilityOn,
  });
}
