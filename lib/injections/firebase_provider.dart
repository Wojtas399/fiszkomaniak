import 'package:fiszkomaniak/firebase/repositories/fire_settings_repository.dart';
import 'package:fiszkomaniak/firebase/services/fire_auth_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_settings_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_user_service.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import 'package:fiszkomaniak/interfaces/settings_interface.dart';
import '../firebase/repositories/fire_auth_repository.dart';

class FirebaseProvider {
  static AuthInterface provideAuthInterface() {
    return FireAuthRepository(
      fireAuthService: FireAuthService(fireUserService: FireUserService()),
    );
  }

  static SettingsInterface provideSettingsInterface() {
    return FireSettingsRepository(
      fireSettingsService: FireSettingsService(),
    );
  }
}
