import 'package:fiszkomaniak/firebase/fire_references.dart';
import 'package:fiszkomaniak/firebase/models/appearance_settings_db_model.dart';

class FireAppearanceSettingsService {
  Future<void> setDefaultSettings() async {
    await FireReferences.appearanceSettingsRefWithConverter.set(
      AppearanceSettingsDbModel(
        isDarkModeOn: false,
        isDarkModeCompatibilityWithSystemOn: false,
        isSessionTimerInvisibilityOn: false,
      ),
    );
  }

  Future<AppearanceSettingsDbModel?> loadSettings() async {
    final settings =
        await FireReferences.appearanceSettingsRefWithConverter.get();
    return settings.data();
  }

  Future<void> updateSettings({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    bool? isSessionTimerInvisibilityOn,
  }) async {
    await FireReferences.appearanceSettingsRefWithConverter.update(
      AppearanceSettingsDbModel(
        isDarkModeOn: isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            isDarkModeCompatibilityWithSystemOn,
        isSessionTimerInvisibilityOn: isSessionTimerInvisibilityOn,
      ).toJson(),
    );
  }
}
