import 'package:firebase_auth/firebase_auth.dart';
import '../../firebase/fire_extensions.dart';
import '../../firebase/services/fire_auth_service.dart';
import '../../interfaces/auth_interface.dart';

class AuthRepository implements AuthInterface {
  late final FireAuthService _fireAuthService;

  AuthRepository({
    required FireAuthService fireAuthService,
  }) {
    _fireAuthService = fireAuthService;
  }

  @override
  Stream<bool> get isUserLogged$ => _fireAuthService.isUserLogged();

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _fireAuthService.signIn(email: email, password: password);
    } on FirebaseAuthException catch (fireAuthException) {
      throw fireAuthException.toAuthException();
    }
  }

  @override
  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final String userId = await _fireAuthService.signUp(
        email: email,
        password: password,
      );
      return userId;
    } on FirebaseAuthException catch (fireAuthException) {
      throw fireAuthException.toAuthException();
    }
  }

  @override
  Future<void> reauthenticate({required String password}) async {
    try {
      await _fireAuthService.reauthenticate(password);
    } on FirebaseAuthException catch (fireAuthException) {
      throw fireAuthException.toAuthException();
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _fireAuthService.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (fireAuthException) {
      throw fireAuthException.toAuthException();
    }
  }

  @override
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _fireAuthService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } on FirebaseAuthException catch (fireAuthException) {
      throw fireAuthException.toAuthException();
    }
  }

  @override
  Future<void> deleteLoggedUserAccount() async {
    await _fireAuthService.deleteLoggedUserAccount();
  }

  @override
  Future<void> signOut() async {
    await _fireAuthService.signOut();
  }
}
