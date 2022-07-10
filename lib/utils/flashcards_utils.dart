import '../domain/entities/flashcard.dart';
import '../domain/entities/session.dart';

class FlashcardsUtils {
  static List<int> getIndexesOfRememberedFlashcards(
    List<Flashcard> flashcards,
  ) {
    return flashcards
        .where((flashcard) => flashcard.status == FlashcardStatus.remembered)
        .map((flashcard) => flashcard.index)
        .toList();
  }

  static List<int> getIndexesOfNotRememberedFlashcards(
    List<Flashcard> flashcards,
  ) {
    return flashcards
        .where((flashcard) => flashcard.status == FlashcardStatus.notRemembered)
        .map((flashcard) => flashcard.index)
        .toList();
  }

  static int getAmountOfFlashcardsMatchingToFlashcardsType(
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

  static bool _doesFlashcardStatusMatchFlashcardsType(
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
