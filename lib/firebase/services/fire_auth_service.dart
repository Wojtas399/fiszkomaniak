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
        throw 'Na podany adres e-mail już zostało zarejestrowane konto...';
      }
    } catch (error) {
      rethrow;
    }
  }
}
