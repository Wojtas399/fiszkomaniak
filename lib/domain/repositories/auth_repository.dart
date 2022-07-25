import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import '../../exceptions/auth_exceptions.dart';
import '../../firebase/services/fire_auth_service.dart';

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
    } on FirebaseAuthException catch (error) {
      throw _getAuthException(error);
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
    } on FirebaseAuthException catch (error) {
      throw _getAuthException(error);
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _fireAuthService.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      throw _getAuthException(error);
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _fireAuthService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } on FirebaseAuthException catch (error) {
      throw _getAuthException(error);
    }
  }

  @override
  Future<void> removeLoggedUser({required String password}) async {
    try {
      await _fireAuthService.removeLoggedUser(password);
    } on FirebaseAuthException catch (error) {
      throw _getAuthException(error);
    }
  }

  @override
  Future<void> signOut() async {
    await _fireAuthService.signOut();
  }

  AuthException _getAuthException(FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
        return AuthException.userNotFound;
      case 'wrong-password':
        return AuthException.wrongPassword;
      case 'invalid-email':
        return AuthException.invalidEmail;
      case 'email-already-in-use':
        return AuthException.emailAlreadyInUse;
      default:
        return AuthException.unknown;
    }
  }
}
