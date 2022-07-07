import 'package:fiszkomaniak/interfaces/appearance_settings_interface.dart';
import '../../entities/appearance_settings.dart';

class GetAppearanceSettingsUseCase {
  late final AppearanceSettingsInterface _appearanceSettingsInterface;

  GetAppearanceSettingsUseCase({
    required AppearanceSettingsInterface appearanceSettingsInterface,
  }) {
    _appearanceSettingsInterface = appearanceSettingsInterface;
  }

  Stream<AppearanceSettings> execute() {
    return _appearanceSettingsInterface.appearanceSettings$;
  }
}
