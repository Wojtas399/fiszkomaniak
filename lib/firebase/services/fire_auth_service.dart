import 'package:firebase_auth/firebase_auth.dart';
import '../fire_instances.dart';

class FireAuthService {
  Stream<User?> getUserChangesStream() {
    return FireInstances.firebaseAuth.userChanges();
  }
}
