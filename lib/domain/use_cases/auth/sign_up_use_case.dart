import '../../../interfaces/achievements_interface.dart';
import '../../../interfaces/appearance_settings_interface.dart';
import '../../../interfaces/auth_interface.dart';
import '../../../interfaces/notifications_settings_interface.dart';
import '../../../interfaces/user_interface.dart';

class SignUpUseCase {
  late final AuthInterface _authInterface;
  late final UserInterface _userInterface;
  late final AchievementsInterface _achievementsInterface;
  late final AppearanceSettingsInterface _appearanceSettingsInterface;
  late final NotificationsSettingsInterface _notificationsSettingsInterface;

  SignUpUseCase({
    required AuthInterface authInterface,
    required UserInterface userInterface,
    required AchievementsInterface achievementsInterface,
    required AppearanceSettingsInterface appearanceSettingsInterface,
    required NotificationsSettingsInterface notificationsSettingsInterface,
  }) {
    _authInterface = authInterface;
    _userInterface = userInterface;
    _achievementsInterface = achievementsInterface;
    _appearanceSettingsInterface = appearanceSettingsInterface;
    _notificationsSettingsInterface = notificationsSettingsInterface;
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
    await _appearanceSettingsInterface.setDefaultSettings();
    await _notificationsSettingsInterface.setDefaultSettings();
  }
}
