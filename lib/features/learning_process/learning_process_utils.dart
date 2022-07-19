import '../../domain/entities/flashcard.dart';
import '../../domain/entities/session.dart';

mixin LearningProcessUtils {
  List<int> getIndexesOfRememberedFlashcards(List<Flashcard> flashcards) {
    return _getIndexesByStatus(flashcards, FlashcardStatus.remembered);
  }

  List<int> getIndexesOfNotRememberedFlashcards(List<Flashcard> flashcards) {
    return _getIndexesByStatus(flashcards, FlashcardStatus.notRemembered);
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

  List<int> _getIndexesByStatus(
    List<Flashcard> flashcards,
    FlashcardStatus status,
  ) {
    return flashcards
        .where((flashcard) => flashcard.status == status)
        .map((flashcard) => flashcard.index)
        .toList();
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
