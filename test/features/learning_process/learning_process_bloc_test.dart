import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_state.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_bloc.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_event.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_state.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlashcardsBloc extends Mock implements FlashcardsBloc {}

void main() {
  final FlashcardsBloc flashcardsBloc = MockFlashcardsBloc();
  late LearningProcessBloc bloc;
  final FlashcardsState flashcardsState = FlashcardsState(
    allFlashcards: [
      createFlashcard(id: 'f1', groupId: 'g1'),
      createFlashcard(id: 'f2', groupId: 'g1'),
      createFlashcard(id: 'f3', groupId: 'g2'),
    ],
  );
  const LearningProcessData data = LearningProcessData(
    groupId: 'g1',
    flashcardsType: FlashcardsType.remembered,
    areQuestionsAndAnswersSwapped: false,
  );
  final LearningProcessState initialState = LearningProcessState(
    data: const LearningProcessData(
      groupId: 'g1',
      flashcardsType: FlashcardsType.remembered,
      areQuestionsAndAnswersSwapped: false,
    ),
    flashcards: [
      flashcardsState.allFlashcards[0],
      flashcardsState.allFlashcards[1],
    ],
  );

  setUp(() {
    bloc = LearningProcessBloc(flashcardsBloc: flashcardsBloc);
    when(() => flashcardsBloc.state).thenReturn(flashcardsState);
  });

  tearDown(() {
    reset(flashcardsBloc);
  });

  blocTest(
    'initialize',
    build: () => bloc,
    act: (_) => bloc.add(LearningProcessEventInitialize(data: data)),
    expect: () => [initialState],
  );

  blocTest(
    'remembered flashcard, new remembered flashcard',
    build: () => bloc,
    act: (_) {
      bloc.add(LearningProcessEventInitialize(data: data));
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardId: 'f1'));
    },
    expect: () => [
      initialState,
      initialState.copyWith(
        idsOfRememberedFlashcards: ['f1'],
        indexOfDisplayedFlashcard: 1,
      ),
    ],
  );

  blocTest(
    'remembered flashcard, existing remembered flashcard',
    build: () => bloc,
    act: (_) {
      bloc.add(LearningProcessEventInitialize(data: data));
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardId: 'f1'));
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardId: 'f1'));
    },
    expect: () => [
      initialState,
      initialState.copyWith(
        idsOfRememberedFlashcards: ['f1'],
        indexOfDisplayedFlashcard: 1,
      ),
    ],
  );

  blocTest(
    'forgotten flashcard',
    build: () => bloc,
    act: (_) {
      bloc.add(LearningProcessEventInitialize(data: data));
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardId: 'f1'));
      bloc.add(LearningProcessEventForgottenFlashcard(flashcardId: 'f1'));
    },
    expect: () => [
      initialState,
      initialState.copyWith(
        idsOfRememberedFlashcards: ['f1'],
        indexOfDisplayedFlashcard: 1,
      ),
      initialState.copyWith(
        idsOfRememberedFlashcards: [],
        indexOfDisplayedFlashcard: 1,
      ),
    ],
  );

  blocTest(
    'reset',
    build: () => bloc,
    act: (_) {
      bloc.add(LearningProcessEventInitialize(data: data));
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardId: 'f1'));
      bloc.add(LearningProcessEventReset());
    },
    expect: () => [
      initialState,
      initialState.copyWith(
        idsOfRememberedFlashcards: ['f1'],
        indexOfDisplayedFlashcard: 1,
      ),
      initialState.copyWith(
        idsOfRememberedFlashcards: ['f1'],
        indexOfDisplayedFlashcard: 0,
      ),
    ],
  );
}
