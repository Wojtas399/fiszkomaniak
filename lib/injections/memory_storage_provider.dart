import 'package:fiszkomaniak/memory_storage/repositories/appearance_settings_storage_repository.dart';
import 'package:fiszkomaniak/memory_storage/settings_storage_service.dart';
import 'package:fiszkomaniak/interfaces/appearance_settings_storage_interface.dart';

class MemoryStorageProvider {
  static AppearanceSettingsStorageInterface
      provideAppearanceSettingsStorageInterface() {
    return AppearanceSettingsStorageRepository(
      settingsStorageService: SettingsStorageService(),
    );
  }
}
