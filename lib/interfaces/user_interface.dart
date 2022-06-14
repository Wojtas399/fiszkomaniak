import 'package:fiszkomaniak/models/user_model.dart';

abstract class UserInterface {
  Stream<String> get loggedUserAvatarUrl$;

  Stream<User> get loggedUserData$;

  Future<void> loadLoggedUserAvatar();

  Future<void> loadLoggedUserData();

  Future<void> addUser({
    required String userId,
    required String username,
  });

  Future<void> saveNewAvatar({required String fullPath});

  Future<void> removeAvatar();

  Future<void> saveNewUsername({required String newUsername});
}
