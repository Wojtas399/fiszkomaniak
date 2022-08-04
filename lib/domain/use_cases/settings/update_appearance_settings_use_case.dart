import '../../../interfaces/settings_interface.dart';

class UpdateAppearanceSettingsUseCase {
  late final SettingsInterface _settingsInterface;

  UpdateAppearanceSettingsUseCase({
    required SettingsInterface settingsInterface,
  }) {
    _settingsInterface = settingsInterface;
  }

  Future<void> execute({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    bool? isSessionTimerInvisibilityOn,
  }) async {
    await _settingsInterface.updateAppearanceSettings(
      isDarkModeOn: isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
      isSessionTimerInvisibilityOn: isSessionTimerInvisibilityOn,
    );
  }
}
