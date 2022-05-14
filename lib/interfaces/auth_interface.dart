abstract class AuthInterface {
  Stream<bool> isLoggedUserStatus();

  Future<void> signIn({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail(String email);

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
