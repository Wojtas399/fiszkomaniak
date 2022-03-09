import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiszkomaniak/interfaces/auth_data_interface.dart';

abstract class AuthInterface {
  Stream<User?> getUserChangesStream();

  signIn();

  Future<void> signUp(AuthDataInterface data);
}
