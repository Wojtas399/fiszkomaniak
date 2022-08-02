import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GroupFlashcardsPreviewState state;

  setUp(
    () => state = const GroupFlashcardsPreviewState(
      groupId: '',
      groupName: '',
      flashcardsFromGroup: [],
      searchValue: '',
    ),
  );

  test(
    'does group have flashcards, should return false if flashcards from group do not exist',
    () {
      expect(state.doesGroupHaveFlashcards, false);
    },
  );

  test(
    'does group have flashcards, should return true if flashcards from group exist',
    () {
      final List<Flashcard> flashcards = [
        createFlashcard(index: 0, question: 'q0', answer: 'a0'),
      ];

      state = state.copyWith(flashcardsFromGroup: flashcards);

      expect(state.doesGroupHaveFlashcards, true);
    },
  );

  test(
    'matching flashcards, should return flashcards whom question or answer match to search value',
    () {
      final List<Flashcard> flashcards = [
        createFlashcard(question: 'question', answer: 'answer'),
        createFlashcard(question: 'guest', answer: 'gość'),
        createFlashcard(question: 'mouth', answer: 'usta'),
        createFlashcard(question: 'arm', answer: 'ręka'),
      ];

      state = state.copyWith(
        flashcardsFromGroup: flashcards,
        searchValue: 'st',
      );

      expect(
        state.matchingFlashcards,
        [
          flashcards[0],
          flashcards[1],
          flashcards[2],
        ],
      );
    },
  );

  test(
    'copy with group id',
    () {
      const String expectedGroupId = 'g1';

      final state2 = state.copyWith(groupId: expectedGroupId);
      final state3 = state2.copyWith();

      expect(state2.groupId, expectedGroupId);
      expect(state3.groupId, expectedGroupId);
    },
  );

  test(
    'copy with group name',
    () {
      const String expectedGroupName = 'group name';

      final state2 = state.copyWith(groupName: expectedGroupName);
      final state3 = state2.copyWith();

      expect(state2.groupName, expectedGroupName);
      expect(state3.groupName, expectedGroupName);
    },
  );

  test(
    'copy with flashcards from group',
    () {
      final List<Flashcard> expectedFlashcardsFromGroup = [
        createFlashcard(index: 0, question: 'q0', answer: 'a0'),
        createFlashcard(index: 1, question: 'q1', answer: 'a1'),
      ];

      final state2 = state.copyWith(
        flashcardsFromGroup: expectedFlashcardsFromGroup,
      );
      final state3 = state2.copyWith();

      expect(state2.flashcardsFromGroup, expectedFlashcardsFromGroup);
      expect(state3.flashcardsFromGroup, expectedFlashcardsFromGroup);
    },
  );

  test(
    'copy with search value',
    () {
      const String expectedSearchValue = 'search value';

      final state2 = state.copyWith(searchValue: expectedSearchValue);
      final state3 = state2.copyWith();

      expect(state2.searchValue, expectedSearchValue);
      expect(state3.searchValue, expectedSearchValue);
    },
  );
}
