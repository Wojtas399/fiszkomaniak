import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_state.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GroupFlashcardsPreviewState state;
  final List<Flashcard> flashcards = [
    createFlashcard(index: 0, question: 'question', answer: 'answer'),
    createFlashcard(index: 1, question: 'What is your name?', answer: 'Jan'),
    createFlashcard(index: 2, question: 'How are you?', answer: 'I am fine'),
  ];

  setUp(() {
    state = const GroupFlashcardsPreviewState();
  });

  test('initial state', () {
    expect(state.groupId, null);
    expect(state.groupName, null);
    expect(state.flashcardsFromGroup, []);
    expect(state.searchValue, '');
  });

  test('copy with group id', () {
    final GroupFlashcardsPreviewState state2 = state.copyWith(groupId: 'g1');
    final GroupFlashcardsPreviewState state3 = state2.copyWith();

    expect(state2.groupId, 'g1');
    expect(state3.groupId, 'g1');
  });

  test('copy with group name', () {
    final GroupFlashcardsPreviewState state2 = state.copyWith(
      groupName: 'groupName',
    );
    final GroupFlashcardsPreviewState state3 = state2.copyWith();

    expect(state2.groupName, 'groupName');
    expect(state3.groupName, 'groupName');
  });

  test('copy with flashcards from group', () {
    final GroupFlashcardsPreviewState state2 = state.copyWith(
      flashcardsFromGroup: flashcards,
    );
    final GroupFlashcardsPreviewState state3 = state2.copyWith();

    expect(state2.flashcardsFromGroup, flashcards);
    expect(state3.flashcardsFromGroup, flashcards);
  });

  test('copy with search value', () {
    final GroupFlashcardsPreviewState state2 = state.copyWith(
      searchValue: 'value',
    );
    final GroupFlashcardsPreviewState state3 = state2.copyWith();

    expect(state2.searchValue, 'value');
    expect(state3.searchValue, 'value');
  });

  test('matching flashcards', () {
    final GroupFlashcardsPreviewState updatedState = state.copyWith(
      flashcardsFromGroup: flashcards,
      searchValue: 'am',
    );

    expect(updatedState.matchingFlashcards, [flashcards[1], flashcards[2]]);
  });
}
