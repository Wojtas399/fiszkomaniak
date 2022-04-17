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

  FlashcardsEditorGroups groupFlashcardsIntoAppropriateGroups(
    List<Flashcard> editedFlashcards,
    List<Flashcard> initialFlashcards,
  ) {
    final List<Flashcard> edited = [];
    final List<Flashcard> added = [];
    final List<String> removed = [];
    final List<String> editedFlashcardsIds =
        _getFlashcardsIds(editedFlashcards);
    final List<String> initialFlashcardsIds =
        _getFlashcardsIds(initialFlashcards);
    for (final flashcard in editedFlashcards) {
      if (flashcard.question.isNotEmpty && flashcard.answer.isNotEmpty) {
        if (initialFlashcardsIds.contains(flashcard.id)) {
          final Flashcard correspondingInitialFlashcard = initialFlashcards
              .firstWhere((element) => element.id == flashcard.id);
          if (_haveFlashcardsDifferentValues(
            flashcard,
            correspondingInitialFlashcard,
          )) {
            edited.add(flashcard);
          }
        } else {
          added.add(flashcard);
        }
      } else if (initialFlashcardsIds.contains(flashcard.id)) {
        removed.add(flashcard.id);
      }
    }
    for (final initialFlashcard in initialFlashcards) {
      if (!editedFlashcardsIds.contains(initialFlashcard.id) &&
          !edited.contains(initialFlashcard) &&
          !removed.contains(initialFlashcard.id)) {
        removed.add(initialFlashcard.id);
      }
    }
    return FlashcardsEditorGroups(
      edited: edited,
      added: added,
      removed: removed,
    );
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

  List<String> _getFlashcardsIds(List<Flashcard> flashcards) {
    return flashcards.map((flashcard) => flashcard.id).toList();
  }

  bool _haveFlashcardsDifferentValues(
    Flashcard flashcard1,
    Flashcard flashcard2,
  ) {
    return flashcard1.answer != flashcard2.answer ||
        flashcard1.question != flashcard2.question;
  }

  bool _areTheSame(Flashcard? flashcard1, Flashcard? flashcard2) {
    return flashcard1?.answer.toLowerCase() ==
            flashcard2?.answer.toLowerCase() &&
        flashcard1?.question.toLowerCase() ==
            flashcard2?.question.toLowerCase();
  }
}
