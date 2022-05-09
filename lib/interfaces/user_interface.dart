import 'package:fiszkomaniak/models/user_model.dart';

abstract class UserInterface {
  Stream<User> getLoggedUserSnapshots();

  Future<void> saveNewRememberedFlashcardsInDays({
    required String groupId,
    required List<int> indexesOfFlashcards,
  });
}
