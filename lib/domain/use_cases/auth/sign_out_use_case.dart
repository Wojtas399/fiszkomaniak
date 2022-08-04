import '../../../interfaces/achievements_interface.dart';
import '../../../interfaces/auth_interface.dart';
import '../../../interfaces/user_interface.dart';
import '../../../interfaces/settings_interface.dart';

class SignOutUseCase {
  late final AuthInterface _authInterface;
  late final UserInterface _userInterface;
  late final AchievementsInterface _achievementsInterface;
  late final SettingsInterface _settingsInterface;

  SignOutUseCase({
    required AuthInterface authInterface,
    required UserInterface userInterface,
    required AchievementsInterface achievementsInterface,
    required SettingsInterface settingsInterface,
  }) {
    _authInterface = authInterface;
    _userInterface = userInterface;
    _achievementsInterface = achievementsInterface;
    _settingsInterface = settingsInterface;
  }

  Future<void> execute() async {
    await _authInterface.signOut();
    _userInterface.reset();
    _achievementsInterface.reset();
    _settingsInterface.reset();
  }
}
