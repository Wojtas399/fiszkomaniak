import '../../../interfaces/achievements_interface.dart';
import '../../../interfaces/auth_interface.dart';
import '../../../interfaces/user_interface.dart';
import '../../../interfaces/settings_interface.dart';

class DeleteLoggedUserAccountUseCase {
  late final UserInterface _userInterface;
  late final AuthInterface _authInterface;
  late final AchievementsInterface _achievementsInterface;
  late final SettingsInterface _settingsInterface;

  DeleteLoggedUserAccountUseCase({
    required UserInterface userInterface,
    required AuthInterface authInterface,
    required AchievementsInterface achievementsInterface,
    required SettingsInterface settingsInterface,
  }) {
    _userInterface = userInterface;
    _authInterface = authInterface;
    _achievementsInterface = achievementsInterface;
    _settingsInterface = settingsInterface;
  }

  Future<void> execute({required String password}) async {
    await _authInterface.reauthenticate(password: password);
    await _userInterface.deleteAvatar();
    await _userInterface.deleteAllUserData();
    await _authInterface.deleteLoggedUserAccount();
    _userInterface.reset();
    _achievementsInterface.reset();
    _settingsInterface.reset();
  }
}
