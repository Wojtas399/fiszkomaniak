import '../../../interfaces/settings_interface.dart';

class LoadSettingsUseCase {
  late final SettingsInterface _settingsInterface;

  LoadSettingsUseCase({required SettingsInterface settingsInterface}) {
    _settingsInterface = settingsInterface;
  }

  Future<void> execute() async {
    await _settingsInterface.loadSettings();
  }
}