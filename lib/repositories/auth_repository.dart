import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiszkomaniak/core/auth/auth_exception_model.dart';
import 'package:fiszkomaniak/interfaces/achievements_interface.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';
import '../firebase/services/fire_auth_service.dart';

class AuthRepository implements AuthInterface {
  late final FireAuthService _fireAuthService;
  late final UserInterface _userInterface;
  late final AchievementsInterface _achievementsInterface;

  AuthRepository({
    required FireAuthService fireAuthService,
    required UserInterface userInterface,
    required AchievementsInterface achievementsInterface,
  }) {
    _fireAuthService = fireAuthService;
    _userInterface = userInterface;
    _achievementsInterface = achievementsInterface;
  }

  @override
  Stream<bool> isLoggedUser() async* {
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
    }
  }

  @override
  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final String? userId = await _fireAuthService.signUp(
        email: email,
        password: password,
      );
      if (userId != null) {
        await _userInterface.addUser(userId: userId, username: username);
        await _achievementsInterface.initializeAchievements();
      }
    } on FirebaseAuthException catch (error) {
      _onFirebaseAuthException(error);
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _fireAuthService.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      _onFirebaseAuthException(error);
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
    }
  }

  @override
  Future<void> removeLoggedUser({required String password}) async {
    try {
      await _fireAuthService.removeLoggedUser(password);
    } on FirebaseAuthException catch (error) {
      _onFirebaseAuthException(error);
    }
  }

  @override
  Future<void> signOut() async {
    await _fireAuthService.signOut();
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
