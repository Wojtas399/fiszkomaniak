import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_state.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LearningProcessState state;
  final List<Flashcard> flashcards = [
    createFlashcard(id: 'f1'),
    createFlashcard(id: 'f2'),
    createFlashcard(id: 'f3'),
  ];
  final List<String> idsOfRememberedFlashcards = ['f1', 'f2'];

  setUp(() {
    state = const LearningProcessState();
  });

  test('initial state', () {
    expect(state.data, null);
    expect(state.flashcards, []);
    expect(state.idsOfRememberedFlashcards, []);
    expect(state.indexOfDisplayedFlashcard, 0);
  });

  test('copy with data', () {
    const LearningProcessData data = LearningProcessData(
      groupId: 'g1',
      flashcardsType: FlashcardsType.remembered,
      areQuestionsAndAnswersSwapped: false,
    );
    final LearningProcessState state2 = state.copyWith(data: data);
    final LearningProcessState state3 = state2.copyWith();

    expect(state2.data, data);
    expect(state3.data, data);
  });

  test('copy with flashcards', () {
    final LearningProcessState state2 = state.copyWith(flashcards: flashcards);
    final LearningProcessState state3 = state2.copyWith();

    expect(state2.flashcards, flashcards);
    expect(state3.flashcards, flashcards);
  });

  test('copy with ids of remembered flashcards', () {
    final LearningProcessState state2 = state.copyWith(
      idsOfRememberedFlashcards: idsOfRememberedFlashcards,
    );
    final LearningProcessState state3 = state2.copyWith();

    expect(state2.idsOfRememberedFlashcards, idsOfRememberedFlashcards);
    expect(state3.idsOfRememberedFlashcards, idsOfRememberedFlashcards);
  });

  test('copy with index of displayed flashcards', () {
    const int indexOfDisplayedFlashcard = 2;
    final LearningProcessState state2 = state.copyWith(
      indexOfDisplayedFlashcard: indexOfDisplayedFlashcard,
    );
    final LearningProcessState state3 = state2.copyWith();

    expect(state2.indexOfDisplayedFlashcard, indexOfDisplayedFlashcard);
    expect(state3.indexOfDisplayedFlashcard, indexOfDisplayedFlashcard);
  });

  test('amount of all flashcards', () {
    final LearningProcessState updatedState = state.copyWith(
      flashcards: flashcards,
    );

    expect(updatedState.amountOfAllFlashcards, flashcards.length);
  });

  test('amount of remembered flashcards', () {
    final LearningProcessState updatedState = state.copyWith(
      idsOfRememberedFlashcards: idsOfRememberedFlashcards,
    );

    expect(
      updatedState.amountOfRememberedFlashcards,
      idsOfRememberedFlashcards.length,
    );
  });
}
