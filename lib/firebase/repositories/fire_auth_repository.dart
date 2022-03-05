import 'package:firebase_auth/firebase_auth.dart';
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
  signIn() {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  signUp() {
    // TODO: implement signUp
    throw UnimplementedError();
  }
}
