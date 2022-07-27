import '../../../interfaces/user_interface.dart';

class DeleteAvatarUseCase {
  late final UserInterface _userInterface;

  DeleteAvatarUseCase({required UserInterface userInterface}) {
    _userInterface = userInterface;
  }

  Future<void> execute() async {
    await _userInterface.deleteAvatar();
  }
}
