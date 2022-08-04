import '../../../interfaces/settings_interface.dart';
import '../../../domain/entities/settings.dart';

class GetAppearanceSettingsUseCase {
  late final SettingsInterface _settingsInterface;

  GetAppearanceSettingsUseCase({
    required SettingsInterface settingsInterface,
  }) {
    _settingsInterface = settingsInterface;
  }

  Stream<AppearanceSettings> execute() {
    return _settingsInterface.appearanceSettings$;
  }
}
