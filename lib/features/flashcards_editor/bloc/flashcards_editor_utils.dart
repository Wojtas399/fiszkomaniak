import '../../../models/flashcard_model.dart';
import 'flashcards_editor_state.dart';

class FlashcardsEditorUtils {
  List<EditorFlashcard> removeEmptyFlashcardsWithoutLastOneAndChangedFlashcard(
    List<EditorFlashcard> flashcards,
    int indexOfEditedFlashcard,
  ) {
    final List<EditorFlashcard> updatedFlashcards =
        flashcards.getRange(0, flashcards.length - 1).toList();
    updatedFlashcards.removeWhere((flashcard) {
      int index = flashcards.indexOf(flashcard);
      return flashcard.doc.question.isEmpty &&
          flashcard.doc.answer.isEmpty &&
          indexOfEditedFlashcard != index;
    });
    updatedFlashcards.add(flashcards.last);
    return updatedFlashcards;
  }

  List<EditorFlashcard> setFlashcardsAsCorrectIfItIsPossible(
    List<EditorFlashcard> flashcards,
  ) {
    final List<EditorFlashcard> updatedFlashcards = [...flashcards];
    final List<EditorFlashcard> incorrectFlashcards =
        updatedFlashcards.where((flashcard) => !flashcard.isCorrect).toList();
    for (final flashcard in incorrectFlashcards) {
      if (flashcard.doc.question.isNotEmpty &&
          flashcard.doc.answer.isNotEmpty) {
        final int index =
            updatedFlashcards.indexWhere((element) => element == flashcard);
        updatedFlashcards[index] =
            updatedFlashcards[index].copyWith(isCorrect: true);
      }
    }
    return updatedFlashcards;
  }

  bool haveChangesBeenMade(
    List<Flashcard> originalFlashcards,
    List<Flashcard> editedFlashcards,
  ) {
    for (final editedFlashcard in editedFlashcards) {
      if (!originalFlashcards.contains(editedFlashcard)) {
        return true;
      }
    }
    return false;
  }

  List<Flashcard> lookForIncorrectlyCompletedFlashcards(
    List<Flashcard> flashcards,
  ) {
    final List<Flashcard> incorrectFlashcards = [];
    for (int i = 0; i < flashcards.length; i++) {
      final Flashcard flashcard = flashcards[i];
      if (flashcard.question == '' || flashcard.answer == '') {
        incorrectFlashcards.add(flashcard);
      }
    }
    return incorrectFlashcards;
  }

  List<Flashcard> lookForDuplicates(List<Flashcard> flashcards) {
    final List<Flashcard?> flashcardsToCheck = [...flashcards];
    final List<Flashcard> duplicates = [];
    for (final flashcard in flashcards) {
      final Flashcard? matchingFlashcard = flashcardsToCheck
          .where((el) => el != flashcard)
          .firstWhere((el) => _areTheSame(el, flashcard), orElse: () => null);
      if (matchingFlashcard != null &&
          !duplicates.contains(flashcard) &&
          !duplicates.contains(matchingFlashcard)) {
        duplicates.addAll([flashcard, matchingFlashcard]);
      }
    }
    return duplicates;
  }

  bool _areTheSame(Flashcard? flashcard1, Flashcard? flashcard2) {
    return flashcard1?.answer.toLowerCase() ==
            flashcard2?.answer.toLowerCase() &&
        flashcard1?.question.toLowerCase() ==
            flashcard2?.question.toLowerCase();
  }
}
