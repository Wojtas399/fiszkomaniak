import '../../../interfaces/settings_interface.dart';
import '../../entities/settings.dart';

class GetSettingsUseCase {
  late final SettingsInterface _settingsInterface;

  GetSettingsUseCase({required SettingsInterface settingsInterface}) {
    _settingsInterface = settingsInterface;
  }

  Stream<Settings> execute() {
    return _settingsInterface.settings$;
  }
}