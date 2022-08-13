import 'package:flutter_test/flutter_test.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_bloc.dart';

class TestLearningProcessUtils with LearningProcessUtils {}

void main() {
  final utils = TestLearningProcessUtils();
  final List<Flashcard> flashcards = [
    createFlashcard(index: 0, status: FlashcardStatus.remembered),
    createFlashcard(index: 1, status: FlashcardStatus.remembered),
    createFlashcard(index: 2, status: FlashcardStatus.notRemembered),
  ];

  test(
    'get remembered flashcards',
    () {
      final List<Flashcard> rememberedFlashcards =
          utils.getRememberedFlashcards(flashcards);

      expect(
        rememberedFlashcards,
        [flashcards[0], flashcards[1]],
      );
    },
  );

  test(
    'get not remembered flashcards',
    () {
      final List<Flashcard> notRememberedFlashcards =
          utils.getNotRememberedFlashcards(flashcards);

      expect(
        notRememberedFlashcards,
        [flashcards.last],
      );
    },
  );

  test(
    'get amount of flashcards matching to flashcards type',
    () {
      final int amountOfMatchingFlashcards =
          utils.getAmountOfFlashcardsMatchingToFlashcardsType(
        flashcards,
        FlashcardsType.remembered,
      );

      expect(amountOfMatchingFlashcards, 2);
    },
  );
}
