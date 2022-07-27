import '../../../interfaces/user_interface.dart';
import '../../entities/user.dart';

class GetUserUseCase {
  late final UserInterface _userInterface;

  GetUserUseCase({required UserInterface userInterface}) {
    _userInterface = userInterface;
  }

  Stream<User?> execute() {
    return _userInterface.user$ ?? Stream.value(null);
  }
}
