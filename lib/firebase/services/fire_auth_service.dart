import 'package:firebase_auth/firebase_auth.dart';
import '../fire_instances.dart';

class FireAuthService {
  Stream<User?> getUserChangesStream() {
    return FireInstances.firebaseAuth.userChanges();
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    print('Username: $username');
    print('Email: $email');
    print('Password: $password');
  }
}
