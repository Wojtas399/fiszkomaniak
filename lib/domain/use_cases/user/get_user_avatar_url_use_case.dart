import '../../../interfaces/user_interface.dart';

class GetUserAvatarUrlUseCase {
  late final UserInterface _userInterface;

  GetUserAvatarUrlUseCase({required UserInterface userInterface}) {
    _userInterface = userInterface;
  }

  Stream<String?> execute() {
    return _userInterface.avatarUrl$;
  }
}
