import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiszkomaniak/core/auth/auth_exception_model.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import '../firebase/services/fire_auth_service.dart';

class AuthRepository implements AuthInterface {
  late final FireAuthService _fireAuthService;

  AuthRepository({required FireAuthService fireAuthService}) {
    _fireAuthService = fireAuthService;
  }

  @override
  Stream<bool> isLoggedUserStatus() async* {
    await for (final user in _fireAuthService.getUserChangesStream()) {
      if (user != null) {
        yield true;
      } else {
        yield false;
      }
    }
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _fireAuthService.signIn(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      _onFirebaseAuthException(error);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      await _fireAuthService.signUp(
        username: username,
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      _onFirebaseAuthException(error);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _fireAuthService.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      _onFirebaseAuthException(error);
    } catch (error) {
      rethrow;
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
      _onFirebaseAuthException(error);
    } catch (error) {
      rethrow;
    }
  }

  void _onFirebaseAuthException(FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
        throw const AuthException(code: AuthErrorCode.userNotFound);
      case 'wrong-password':
        throw const AuthException(code: AuthErrorCode.wrongPassword);
      case 'invalid-email':
        throw const AuthException(code: AuthErrorCode.invalidEmail);
      case 'email-already-in-use':
        throw const AuthException(code: AuthErrorCode.emailAlreadyInUse);
      default:
        throw error;
    }
  }
}
