abstract class AuthInterface {
  Stream<bool> get isUserLogged$;

  Future<void> signIn({
    required String email,
    required String password,
  });

  Future<String> signUp({
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail(String email);

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> removeLoggedUser({required String password});

  Future<void> signOut();
}
