import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiszkomaniak/firebase/services/fire_user_service.dart';
import '../fire_instances.dart';

class FireAuthService {
  late final FireUserService _fireUserService;

  FireAuthService({required FireUserService fireUserService}) {
    _fireUserService = fireUserService;
  }

  Stream<User?> getUserChangesStream() {
    return FireInstances.auth.userChanges();
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await FireInstances.auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        throw 'Nie znaleziono użytkownika zarejestrowanego na podany adres email.';
      } else if (error.code == 'wrong-password') {
        throw 'Podano niepoprawne hasło dla tego użytkownika.';
      }
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await FireInstances.auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        await _fireUserService.addUser(user.uid, username);
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        throw 'Na podany adres e-mail już zostało zarejestrowane konto.';
      }
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await FireInstances.auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        throw 'Nie znaleziono konta zarejestrowanego na podany adres email.';
      } else if (error.code == 'invalid-email') {
        throw 'Podano niepoprawny adres email.';
      }
      rethrow;
    } catch (error) {
      rethrow;
    }
  }
}
