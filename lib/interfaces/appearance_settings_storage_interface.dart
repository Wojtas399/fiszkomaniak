import 'package:fiszkomaniak/models/settings/appearance_settings_model.dart';

abstract class AppearanceSettingsStorageInterface {
  Future<void> save({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    bool? isSessionTimerVisibilityOn,
  });

  Future<AppearanceSettings> load();
}
