import 'package:firebase_auth/firebase_auth.dart';
import '../fire_user.dart';
import '../fire_instances.dart';

class FireAuthService {
  Stream<bool> isUserLogged() {
    return FireInstances.auth.userChanges().map((user) => user != null);
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await FireInstances.auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential =
        await FireInstances.auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    if (user != null) {
      return user.uid;
    }
    throw FirebaseAuthException(code: 'cannot-register-user');
  }

  Future<void> reauthenticate(String password) async {
    final User? loggedUser = FireUser.loggedUser;
    final String? loggedUserEmail = loggedUser?.email;
    if (loggedUser != null && loggedUserEmail != null) {
      final AuthCredential credential = EmailAuthProvider.credential(
        email: loggedUserEmail,
        password: password,
      );
      await loggedUser.reauthenticateWithCredential(credential);
    } else {
      throw FireUser.noLoggedUserMessage;
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await FireInstances.auth.sendPasswordResetEmail(email: email);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await reauthenticate(currentPassword);
    await FireUser.loggedUser?.updatePassword(newPassword);
  }

  Future<void> deleteLoggedUserAccount() async {
    await FireUser.loggedUser?.delete();
  }

  Future<void> signOut() async {
    await FireInstances.auth.signOut();
  }
}
