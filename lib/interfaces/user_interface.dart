import 'package:fiszkomaniak/models/user_model.dart';

abstract class UserInterface {
  Stream<User> getLoggedUserSnapshots();

  Future<void> saveNewAvatar({required String fullPath});

  Future<void> removeAvatar();

  Future<void> saveNewUsername({required String newUsername});

  Future<void> saveNewRememberedFlashcardsInDays({
    required String groupId,
    required List<int> indexesOfFlashcards,
  });
}
