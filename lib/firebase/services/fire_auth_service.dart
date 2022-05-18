import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiszkomaniak/firebase/fire_user.dart';
import 'package:fiszkomaniak/firebase/services/fire_avatar_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_user_service.dart';
import '../fire_instances.dart';

class FireAuthService {
  late final FireUserService _fireUserService;
  late final FireAvatarService _fireAvatarService;

  FireAuthService({
    required FireUserService fireUserService,
    required FireAvatarService fireAvatarService,
  }) {
    _fireUserService = fireUserService;
    _fireAvatarService = fireAvatarService;
  }

  Stream<User?> getUserChangesStream() {
    return FireInstances.auth.userChanges();
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await FireInstances.auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    UserCredential userCredential =
        await FireInstances.auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    if (user != null) {
      await _fireUserService.addUser(user.uid, username);
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await FireInstances.auth.sendPasswordResetEmail(email: email);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _reauthenticate(currentPassword);
    await FireUser.loggedUser?.updatePassword(newPassword);
  }

  Future<void> removeLoggedUser(String password) async {
    final User? loggedUser = FireUser.loggedUser;
    if (loggedUser != null) {
      await _reauthenticate(password);
      await _fireUserService.removeLoggedUserData();
      if (await _fireAvatarService.doesLoggedUserAvatarExist()) {
        await _fireAvatarService.removeLoggedUserAvatar();
      }
      await loggedUser.delete();
    }
  }

  Future<void> signOut() async {
    await FireInstances.auth.signOut();
  }

  Future<void> _reauthenticate(String password) async {
    final User? loggedUser = FireUser.loggedUser;
    final String? loggedUserEmail = loggedUser?.email;
    if (loggedUser != null && loggedUserEmail != null) {
      final AuthCredential credential = EmailAuthProvider.credential(
        email: loggedUserEmail,
        password: password,
      );
      await loggedUser.reauthenticateWithCredential(credential);
    } else {
      throw FireUser.noLoggedUserMessage;
    }
  }
}
