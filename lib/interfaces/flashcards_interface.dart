import 'package:fiszkomaniak/models/flashcard_model.dart';

abstract class FlashcardsInterface {
  Future<void> saveEditedFlashcards({
    required String groupId,
    required List<Flashcard> flashcards,
  });

  Future<void> saveRememberedFlashcards({
    required String groupId,
    required List<int> flashcardsIndexes,
  });

  Future<void> updateFlashcard({
    required String groupId,
    required Flashcard flashcard,
  });

  Future<void> removeFlashcard({
    required String groupId,
    required Flashcard flashcard,
  });

  Stream<List<Flashcard>> getFlashcardsFromGroup({required String groupId});

  Stream<int> getAmountOfAllFlashcardsFromGroup({required String groupId});

  Stream<int> getAmountOfRememberedFlashcardsFromGroup({
    required String groupId,
  });
}
