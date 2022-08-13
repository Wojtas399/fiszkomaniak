part of 'learning_process_bloc.dart';

mixin LearningProcessUtils {
  List<Flashcard> getRememberedFlashcards(List<Flashcard> flashcards) {
    return _getFlashcardsByStatus(flashcards, FlashcardStatus.remembered);
  }

  List<Flashcard> getNotRememberedFlashcards(List<Flashcard> flashcards) {
    return _getFlashcardsByStatus(flashcards, FlashcardStatus.notRemembered);
  }

  int getAmountOfFlashcardsMatchingToFlashcardsType(
    List<Flashcard> flashcards,
    FlashcardsType type,
  ) {
    return flashcards
        .where(
          (flashcard) => _doesFlashcardStatusMatchFlashcardsType(
            flashcard.status,
            type,
          ),
        )
        .length;
  }

  List<Flashcard> _getFlashcardsByStatus(
    List<Flashcard> flashcards,
    FlashcardStatus status,
  ) {
    return flashcards.where((flashcard) => flashcard.status == status).toList();
  }

  bool _doesFlashcardStatusMatchFlashcardsType(
    FlashcardStatus flashcardStatus,
    FlashcardsType flashcardsType,
  ) {
    switch (flashcardsType) {
      case FlashcardsType.all:
        return true;
      case FlashcardsType.remembered:
        return flashcardStatus == FlashcardStatus.remembered;
      case FlashcardsType.notRemembered:
        return flashcardStatus == FlashcardStatus.notRemembered;
    }
  }
}
