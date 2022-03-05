import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthInterface {
  Stream<User?> getUserChangesStream();

  signIn();

  signUp();
}
