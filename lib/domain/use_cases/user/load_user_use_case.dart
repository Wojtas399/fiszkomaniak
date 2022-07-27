import '../../../interfaces/user_interface.dart';

class LoadUserUseCase {
  late final UserInterface _userInterface;

  LoadUserUseCase({
    required UserInterface userInterface,
  }) {
    _userInterface = userInterface;
  }

  Future<void> execute() async {
    await _userInterface.loadUser();
  }
}
