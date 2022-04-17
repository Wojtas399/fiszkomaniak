import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiszkomaniak/models/sign_in_model.dart';
import 'package:fiszkomaniak/models/sign_up_model.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import '../services/fire_auth_service.dart';

class AuthRepository implements AuthInterface {
  late final FireAuthService _fireAuthService;

  AuthRepository({required FireAuthService fireAuthService}) {
    _fireAuthService = fireAuthService;
  }

  @override
  Stream<User?> getUserChangesStream() {
    return _fireAuthService.getUserChangesStream();
  }

  @override
  Future<void> signIn(SignInModel data) async {
    await _fireAuthService.signIn(
      email: data.email,
      password: data.password,
    );
  }

  @override
  Future<void> signUp(SignUpModel data) async {
    await _fireAuthService.signUp(
      username: data.username,
      email: data.email,
      password: data.password,
    );
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _fireAuthService.sendPasswordResetEmail(email: email);
  }
}
