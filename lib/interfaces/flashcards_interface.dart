import 'package:fiszkomaniak/models/flashcard_model.dart';

abstract class FlashcardsInterface {
  Future<void> setFlashcards({
    required String groupId,
    required List<Flashcard> flashcards,
  }) async {}

  Future<void> updateFlashcard({
    required String groupId,
    required Flashcard flashcard,
  }) async {}

  Future<void> removeFlashcard({
    required String groupId,
    required Flashcard flashcard,
  }) async {}
}
