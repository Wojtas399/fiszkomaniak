import '../../../interfaces/user_interface.dart';

class UpdateUserUsernameUseCase {
  late final UserInterface _userInterface;

  UpdateUserUsernameUseCase({required UserInterface userInterface}) {
    _userInterface = userInterface;
  }

  Future<void> execute({
    required String username,
  }) async {
    await _userInterface.updateUsername(newUsername: username);
  }
}
