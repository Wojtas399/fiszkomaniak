import 'package:fiszkomaniak/interfaces/appearance_settings_interface.dart';

class LoadAppearanceSettingsUseCase {
  late final AppearanceSettingsInterface _appearanceSettingsInterface;

  LoadAppearanceSettingsUseCase({
    required AppearanceSettingsInterface appearanceSettingsInterface,
  }) {
    _appearanceSettingsInterface = appearanceSettingsInterface;
  }

  Future<void> execute() async {
    await _appearanceSettingsInterface.loadSettings();
  }
}
