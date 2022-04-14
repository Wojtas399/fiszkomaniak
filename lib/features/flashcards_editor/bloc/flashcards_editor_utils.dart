import '../../../models/flashcard_model.dart';
import 'flashcards_editor_bloc.dart';

class FlashcardsEditorUtils {
  bool areFlashcardsCompletedCorrectly(List<Flashcard> flashcards) {
    for (int i = 0; i < flashcards.length - 1; i++) {
      final Flashcard flashcard = flashcards[i];
      if (flashcard.question == '' || flashcard.answer == '') {
        return false;
      }
    }
    return true;
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
      if (areFlashcardBothFieldsCompleted(flashcard)) {
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

  bool areFlashcardBothFieldsCompleted(Flashcard flashcard) {
    return flashcard.question != '' && flashcard.answer != '';
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
}
