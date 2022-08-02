import 'package:fiszkomaniak/interfaces/appearance_settings_interface.dart';

class UpdateAppearanceSettingsUseCase {
  late final AppearanceSettingsInterface _appearanceSettingsInterface;

  UpdateAppearanceSettingsUseCase({
    required AppearanceSettingsInterface appearanceSettingsInterface,
  }) {
    _appearanceSettingsInterface = appearanceSettingsInterface;
  }

  Future<void> execute({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    bool? isSessionTimerInvisibilityOn,
  }) async {
    await _appearanceSettingsInterface.updateSettings(
      isDarkModeOn: isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
      isSessionTimerInvisibilityOn: isSessionTimerInvisibilityOn,
    );
  }
}
