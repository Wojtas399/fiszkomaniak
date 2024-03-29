import '../../../interfaces/achievements_interface.dart';
import '../../../interfaces/auth_interface.dart';
import '../../../interfaces/settings_interface.dart';
import '../../../interfaces/user_interface.dart';

class SignUpUseCase {
  late final AuthInterface _authInterface;
  late final UserInterface _userInterface;
  late final AchievementsInterface _achievementsInterface;
  late final SettingsInterface _settingsInterface;

  SignUpUseCase({
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

  Future<void> execute({
    required String username,
    required String email,
    required String password,
  }) async {
    final String userId = await _authInterface.signUp(
      email: email,
      password: password,
    );
    await _userInterface.addUserData(userId: userId, username: username);
    await _achievementsInterface.setInitialAchievements();
    await _settingsInterface.setDefaultSettings();
  }
}
