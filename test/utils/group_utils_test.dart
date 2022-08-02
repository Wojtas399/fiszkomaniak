import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:fiszkomaniak/utils/group_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('get available flashcards types', () {
    test('all flashcards are remembered', () {
      final Group group = createGroup(
        flashcards: [
          createFlashcard(index: 0, status: FlashcardStatus.remembered),
          createFlashcard(index: 1, status: FlashcardStatus.remembered),
          createFlashcard(index: 2, status: FlashcardStatus.remembered),
        ],
      );

      final List<FlashcardsType> types =
          GroupUtils.getAvailableFlashcardsTypes(group);

      expect(types, [FlashcardsType.all]);
    });

    test('all flashcards are not remembered', () {
      final Group group = createGroup(
        flashcards: [
          createFlashcard(index: 0, status: FlashcardStatus.notRemembered),
          createFlashcard(index: 1, status: FlashcardStatus.notRemembered),
          createFlashcard(index: 2, status: FlashcardStatus.notRemembered),
        ],
      );

      final List<FlashcardsType> types =
          GroupUtils.getAvailableFlashcardsTypes(group);

      expect(types, [FlashcardsType.all]);
    });

    test('there are remembered and not remembered flashcards', () {
      final Group group = createGroup(
        flashcards: [
          createFlashcard(index: 0, status: FlashcardStatus.remembered),
          createFlashcard(index: 1, status: FlashcardStatus.notRemembered),
          createFlashcard(index: 2, status: FlashcardStatus.notRemembered),
        ],
      );

      final List<FlashcardsType> types =
          GroupUtils.getAvailableFlashcardsTypes(group);

      expect(types, FlashcardsType.values);
    });
  });
}
