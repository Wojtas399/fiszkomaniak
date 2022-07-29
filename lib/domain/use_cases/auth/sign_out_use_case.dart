import '../../../interfaces/achievements_interface.dart';
import '../../../interfaces/auth_interface.dart';
import '../../../interfaces/user_interface.dart';

class SignOutUseCase {
  late final AuthInterface _authInterface;
  late final UserInterface _userInterface;
  late final AchievementsInterface _achievementsInterface;

  SignOutUseCase({
    required AuthInterface authInterface,
    required UserInterface userInterface,
    required AchievementsInterface achievementsInterface,
  }) {
    _authInterface = authInterface;
    _userInterface = userInterface;
    _achievementsInterface = achievementsInterface;
  }

  Future<void> execute() async {
    await _authInterface.signOut();
    _userInterface.reset();
    _achievementsInterface.reset();
  }
}
