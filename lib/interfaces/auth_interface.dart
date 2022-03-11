import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiszkomaniak/interfaces/sign_in_model_interface.dart';
import 'package:fiszkomaniak/interfaces/sign_up_model_interface.dart';

abstract class AuthInterface {
  Stream<User?> getUserChangesStream();

  Future<void> signIn(SignInModelInterface data);

  Future<void> signUp(SignUpModelInterface data);
}
