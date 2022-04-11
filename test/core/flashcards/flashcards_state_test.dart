import 'package:fiszkomaniak/core/flashcards/flashcards_state.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_status.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FlashcardsState state;
  final List<Flashcard> flashcards = [
    createFlashcard(id: 'f1', groupId: 'g1'),
    createFlashcard(id: 'f2', groupId: 'g1'),
    createFlashcard(id: 'f3', groupId: 'g2'),
    createFlashcard(id: 'f4', groupId: 'g1'),
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
    final List<Flashcard> expectedFlashcards = flashcards
        .where(
          (flashcard) => flashcard.groupId == 'g1',
        )
        .toList();
    final FlashcardsState updatedState = state.copyWith(
      allFlashcards: flashcards,
    );

    final List<Flashcard> flashcardsFromGroup =
        updatedState.getFlashcardsFromGroup('g1');

    expect(flashcardsFromGroup, expectedFlashcards);
  });
}
