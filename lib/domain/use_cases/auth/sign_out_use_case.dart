import '../../../interfaces/auth_interface.dart';
import '../../../interfaces/user_interface.dart';

class SignOutUseCase {
  late final AuthInterface _authInterface;
  late final UserInterface _userInterface;

  SignOutUseCase({
    required AuthInterface authInterface,
    required UserInterface userInterface,
  }) {
    _authInterface = authInterface;
    _userInterface = userInterface;
  }

  Future<void> execute() async {
    await _authInterface.signOut();
    _userInterface.reset();
  }
}
