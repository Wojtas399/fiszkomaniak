import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiszkomaniak/models/sign_in_model.dart';
import 'package:fiszkomaniak/models/sign_up_model.dart';

abstract class AuthInterface {
  Stream<User?> getUserChangesStream();

  Future<void> signIn(SignInModel data);

  Future<void> signUp(SignUpModel data);
}
