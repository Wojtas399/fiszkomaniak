import '../../../interfaces/user_interface.dart';

class UpdateAvatarUseCase {
  late final UserInterface _userInterface;

  UpdateAvatarUseCase({required UserInterface userInterface}) {
    _userInterface = userInterface;
  }

  Future<void> execute({required String imagePath}) async {
    await _userInterface.updateAvatar(imagePath: imagePath);
  }
}
