import '../domain/entities/user.dart';

abstract class UserInterface {
  Stream<User>? get user$;

  Stream<String?>? get avatarUrl$;

  Future<void> loadUser();

  Future<void> addUserData({
    required String userId,
    required String username,
  });

  Future<void> updateAvatar({required String imagePath});

  Future<void> updateUsername({required String newUsername});

  Future<void> deleteAvatar();

  Future<void> deleteAllUserData();

  void reset();
}
