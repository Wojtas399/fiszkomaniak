import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiszkomaniak/interfaces/sign_in_model_interface.dart';
import 'package:fiszkomaniak/interfaces/sign_up_model_interface.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import '../services/fire_auth_service.dart';

class FireAuthRepository implements AuthInterface {
  late final FireAuthService _fireAuthService;

  FireAuthRepository({required FireAuthService fireAuthService}) {
    _fireAuthService = fireAuthService;
  }

  @override
  Stream<User?> getUserChangesStream() {
    return _fireAuthService.getUserChangesStream();
  }

  @override
  Future<void> signIn(SignInModelInterface data) async {
    await _fireAuthService.signIn(
      email: data.getEmail(),
      password: data.getPassword(),
    );
  }

  @override
  Future<void> signUp(SignUpModelInterface data) async {
    await _fireAuthService.signUp(
      username: data.getUsername(),
      email: data.getEmail(),
      password: data.getPassword(),
    );
  }
}
