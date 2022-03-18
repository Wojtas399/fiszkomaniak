import 'package:fiszkomaniak/memory_storage/settings_storage_service.dart';
import 'package:fiszkomaniak/interfaces/appearance_settings_storage_interface.dart';
import 'package:fiszkomaniak/models/settings/appearance_settings_model.dart';

class AppearanceSettingsStorageRepository
    implements AppearanceSettingsStorageInterface {
  late final SettingsStorageService _settingsStorageService;

  AppearanceSettingsStorageRepository({
    required SettingsStorageService settingsStorageService,
  }) {
    _settingsStorageService = settingsStorageService;
  }

  @override
  Future<AppearanceSettings> load() async {
    Map<String, bool> appearanceSettings =
        await _settingsStorageService.loadSettings(
      [
        'isDarkModeOn',
        'isDarkModeCompatibilityWithSystemOn',
        'isSessionTimerVisibilityOn',
      ],
    );
    return AppearanceSettings(
      isDarkModeOn: appearanceSettings['isDarkModeOn'] ?? false,
      isDarkModeCompatibilityWithSystemOn:
          appearanceSettings['isDarkModeCompatibilityWithSystemOn'] ?? false,
      isSessionTimerVisibilityOn:
          appearanceSettings['isSessionTimerVisibilityOn'] ?? false,
    );
  }

  @override
  Future<void> save({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    bool? isSessionTimerVisibilityOn,
  }) async {
    if (isDarkModeOn != null) {
      await _settingsStorageService.saveParameter(
        SettingsStorageBoolParameter(key: 'isDarkModeOn', value: isDarkModeOn),
      );
    }
    if (isDarkModeCompatibilityWithSystemOn != null) {
      await _settingsStorageService.saveParameter(
        SettingsStorageBoolParameter(
          key: 'isDarkModeCompatibilityWithSystemOn',
          value: isDarkModeCompatibilityWithSystemOn,
        ),
      );
    }
    if (isSessionTimerVisibilityOn != null) {
      await _settingsStorageService.saveParameter(
        SettingsStorageBoolParameter(
          key: 'isSessionTimerVisibilityOn',
          value: isSessionTimerVisibilityOn,
        ),
      );
    }
  }
}
