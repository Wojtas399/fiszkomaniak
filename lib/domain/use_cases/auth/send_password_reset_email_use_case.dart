import 'package:fiszkomaniak/interfaces/auth_interface.dart';

class SendPasswordResetEmailUseCase {
  late final AuthInterface _authInterface;

  SendPasswordResetEmailUseCase({required AuthInterface authInterface}) {
    _authInterface = authInterface;
  }

  Future<void> execute({required String email}) async {
    await _authInterface.sendPasswordResetEmail(email);
  }
}
