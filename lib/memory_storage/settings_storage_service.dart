import 'package:shared_preferences/shared_preferences.dart';

class SettingsStorageService {
  Future<Map<String, bool>> loadSettings(List<String> settingsKeys) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Map<String, bool> settingsParams = <String, bool>{};
      for (final key in settingsKeys) {
        settingsParams[key] = prefs.getBool(key) ?? false;
      }
      return settingsParams;
    } catch (error) {
      throw 'Cannot load settings';
    }
  }

  Future<void> saveParameter(SettingsStorageBoolParameter parameter) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool(parameter.key, parameter.value);
    } catch (error) {
      rethrow;
    }
  }
}

class SettingsStorageBoolParameter {
  final String key;
  final bool value;

  SettingsStorageBoolParameter({required this.key, required this.value});
}
