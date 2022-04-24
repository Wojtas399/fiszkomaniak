import 'package:fiszkomaniak/core/flashcards/flashcards_state.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_status.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FlashcardsState state;
  final List<Flashcard> flashcards = [
    createFlashcard(
      id: 'f1',
      groupId: 'g1',
      status: FlashcardStatus.remembered,
    ),
    createFlashcard(
      id: 'f2',
      groupId: 'g1',
      status: FlashcardStatus.notRemembered,
    ),
    createFlashcard(id: 'f3', groupId: 'g2'),
    createFlashcard(
      id: 'f4',
      groupId: 'g1',
      status: FlashcardStatus.notRemembered,
    ),
  ];

  setUp(() {
    state = const FlashcardsState();
  });

  test('initial state', () {
    expect(state.allFlashcards, const []);
    expect(state.status, const FlashcardsStatusInitial());
  });

  test('copy with all flashcards', () {
    final FlashcardsState state2 = state.copyWith(allFlashcards: flashcards);
    final FlashcardsState state3 = state2.copyWith();

    expect(state2.allFlashcards, flashcards);
    expect(state3.allFlashcards, flashcards);
  });

  test('copy with status', () {
    final FlashcardsState state2 = state.copyWith(
      status: FlashcardsStatusLoading(),
    );
    final FlashcardsState state3 = state2.copyWith();

    expect(state2.status, FlashcardsStatusLoading());
    expect(state3.status, FlashcardsStatusLoaded());
  });

  test('get flashcards from group', () {
    final List<Flashcard> expectedFlashcards =
        flashcards.where((flashcard) => flashcard.groupId == 'g1').toList();
    final FlashcardsState updatedState = state.copyWith(
      allFlashcards: flashcards,
    );

    final List<Flashcard> flashcardsFromGroup =
        updatedState.getFlashcardsByGroupId('g1');

    expect(flashcardsFromGroup, expectedFlashcards);
  });

  test('get amount of all flashcards from group', () {
    final FlashcardsState updatedState = state.copyWith(
      allFlashcards: flashcards,
    );

    final int amount = updatedState.getAmountOfAllFlashcardsFromGroup('g1');

    expect(amount, 3);
  });

  test('get amount of remembered flashcards from group', () {
    final FlashcardsState updatedState = state.copyWith(
      allFlashcards: flashcards,
    );

    final int amount =
        updatedState.getAmountOfRememberedFlashcardsFromGroup('g1');

    expect(amount, 1);
  });

  test('get flashcard by id, flashcard exists', () {
    final FlashcardsState updatedState = state.copyWith(
      allFlashcards: flashcards,
    );

    final Flashcard? flashcard = updatedState.getFlashcardById('f1');

    expect(flashcard, flashcards[0]);
  });

  test('get flashcard by id, flashcard does not exist', () {
    final FlashcardsState updatedState = state.copyWith(
      allFlashcards: flashcards,
    );

    final Flashcard? flashcard = updatedState.getFlashcardById('f5');

    expect(flashcard, null);
  });
}
