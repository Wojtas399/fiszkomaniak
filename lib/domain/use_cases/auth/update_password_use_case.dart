import '../../../interfaces/auth_interface.dart';

class UpdatePasswordUseCase {
  late final AuthInterface _authInterface;

  UpdatePasswordUseCase({required AuthInterface authInterface}) {
    _authInterface = authInterface;
  }

  Future<void> execute({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _authInterface.updatePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
