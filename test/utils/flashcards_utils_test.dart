import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:fiszkomaniak/utils/flashcards_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final List<Flashcard> flashcards = [
    createFlashcard(index: 0, status: FlashcardStatus.remembered),
    createFlashcard(index: 1, status: FlashcardStatus.remembered),
    createFlashcard(index: 2, status: FlashcardStatus.notRemembered),
  ];

  test('get indexes of remembered flashcards', () {
    final List<int> indexesOfRememberedFlashcards =
        FlashcardsUtils.getIndexesOfRememberedFlashcards(flashcards);

    expect(indexesOfRememberedFlashcards, [0, 1]);
  });

  test('get indexes of not remembered flashcards', () {
    final List<int> indexesOfRememberedFlashcards =
        FlashcardsUtils.getIndexesOfNotRememberedFlashcards(flashcards);

    expect(indexesOfRememberedFlashcards, [2]);
  });

  group('get amount of flashcards matching to flashcards type', () {
    test('flashcards type all', () {
      final amount =
          FlashcardsUtils.getAmountOfFlashcardsMatchingToFlashcardsType(
              flashcards, FlashcardsType.all);

      expect(amount, 3);
    });

    test('flashcards type remembered', () {
      final amount =
          FlashcardsUtils.getAmountOfFlashcardsMatchingToFlashcardsType(
              flashcards, FlashcardsType.remembered);

      expect(amount, 2);
    });

    test('flashcards type not remembered', () {
      final amount =
          FlashcardsUtils.getAmountOfFlashcardsMatchingToFlashcardsType(
              flashcards, FlashcardsType.notRemembered);

      expect(amount, 1);
    });
  });
}
