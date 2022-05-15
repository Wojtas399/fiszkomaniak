import 'package:fiszkomaniak/core/flashcards/flashcards_state.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_status.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FlashcardsState state;
  final GroupsState groupsState = GroupsState(
    allGroups: [
      createGroup(
        id: 'g1',
        flashcards: [
          createFlashcard(
            index: 0,
            question: 'q0',
            answer: 'a0',
            status: FlashcardStatus.remembered,
          ),
          createFlashcard(
            index: 1,
            question: 'q1',
            answer: 'a1',
            status: FlashcardStatus.remembered,
          ),
          createFlashcard(
            index: 2,
            question: 'q2',
            answer: 'a2',
            status: FlashcardStatus.notRemembered,
          ),
        ],
      ),
      createGroup(
        id: 'g2',
        flashcards: [
          createFlashcard(index: 0, question: 'question 0', answer: 'answer 0'),
          createFlashcard(index: 1, question: 'question 1', answer: 'answer 1'),
        ],
      ),
    ],
  );

  setUp(() {
    state = FlashcardsState(groupsState: groupsState);
  });

  test('initial state', () {
    const FlashcardsState initialState = FlashcardsState();

    expect(initialState.groupsState, const GroupsState());
    expect(initialState.status, const FlashcardsStatusInitial());
  });

  test('copy with groups state', () {
    final GroupsState newGroupsState = GroupsState(
      allGroups: [createGroup(id: 'g1')],
    );
    final FlashcardsState state2 = state.copyWith(groupsState: newGroupsState);
    final FlashcardsState state3 = state2.copyWith();

    expect(state2.groupsState, newGroupsState);
    expect(state3.groupsState, newGroupsState);
  });

  test('copy with status', () {
    final FlashcardsState state2 = state.copyWith(
      status: FlashcardsStatusLoading(),
    );
    final FlashcardsState state3 = state2.copyWith();

    expect(state2.status, FlashcardsStatusLoading());
    expect(state3.status, FlashcardsStatusLoaded());
  });

  test('amount of all flashcards', () {
    final int amount = state.amountOfAllFlashcards;

    expect(amount, 5);
  });

  test('get flashcards from group', () {
    final List<Flashcard> expectedFlashcards =
        groupsState.allGroups[0].flashcards;

    final List<Flashcard> flashcardsFromGroup =
        state.getFlashcardsFromGroup('g1');

    expect(flashcardsFromGroup, expectedFlashcards);
  });

  test('get amount of all flashcards from group', () {
    final int amount = state.getAmountOfAllFlashcardsFromGroup('g1');

    expect(amount, 3);
  });

  test('get amount of remembered flashcards from group', () {
    final int amount = state.getAmountOfRememberedFlashcardsFromGroup('g1');

    expect(amount, 2);
  });

  test('get flashcard from group', () {
    final Flashcard? flashcard = state.getFlashcardFromGroup('g1', 1);

    expect(flashcard, groupsState.allGroups[0].flashcards[1]);
  });
}
