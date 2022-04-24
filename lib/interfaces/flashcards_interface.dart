import 'package:fiszkomaniak/models/changed_document.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';

abstract class FlashcardsInterface {
  Stream<List<ChangedDocument<Flashcard>>> getFlashcardsSnapshots();

  Future<void> addFlashcards(List<Flashcard> flashcards) async {}

  Future<void> updateFlashcards(List<Flashcard> flashcards) async {}

  Future<void> removeFlashcards(List<String> idsOfFlashcards) async {}
}
