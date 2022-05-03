import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_state.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_bloc.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_event.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_state.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlashcardsBloc extends Mock implements FlashcardsBloc {}

void main() {
  final FlashcardsBloc flashcardsBloc = MockFlashcardsBloc();
  late LearningProcessBloc bloc;
  final FlashcardsState flashcardsState = FlashcardsState(
    groupsState: GroupsState(
      allGroups: [
        createGroup(
          id: 'g1',
          flashcards: [
            createFlashcard(index: 0, question: 'q0', answer: 'a0'),
            createFlashcard(index: 1, question: 'q1', answer: 'a1'),
          ],
        ),
        createGroup(id: 'g2'),
      ],
    ),
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
    flashcards: flashcardsState.groupsState.allGroups[0].flashcards,
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
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardIndex: 0));
    },
    expect: () => [
      initialState,
      initialState.copyWith(
        indexesOfRememberedFlashcards: [0],
        indexOfDisplayedFlashcard: 1,
      ),
    ],
  );

  blocTest(
    'remembered flashcard, existing remembered flashcard',
    build: () => bloc,
    act: (_) {
      bloc.add(LearningProcessEventInitialize(data: data));
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardIndex: 0));
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardIndex: 0));
    },
    expect: () => [
      initialState,
      initialState.copyWith(
        indexesOfRememberedFlashcards: [0],
        indexOfDisplayedFlashcard: 1,
      ),
    ],
  );

  blocTest(
    'forgotten flashcard',
    build: () => bloc,
    act: (_) {
      bloc.add(LearningProcessEventInitialize(data: data));
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardIndex: 0));
      bloc.add(LearningProcessEventForgottenFlashcard(flashcardIndex: 0));
    },
    expect: () => [
      initialState,
      initialState.copyWith(
        indexesOfRememberedFlashcards: [0],
        indexOfDisplayedFlashcard: 1,
      ),
      initialState.copyWith(
        indexesOfRememberedFlashcards: [],
        indexOfDisplayedFlashcard: 1,
      ),
    ],
  );

  blocTest(
    'reset',
    build: () => bloc,
    act: (_) {
      bloc.add(LearningProcessEventInitialize(data: data));
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardIndex: 0));
      bloc.add(LearningProcessEventReset());
    },
    expect: () => [
      initialState,
      initialState.copyWith(
        indexesOfRememberedFlashcards: [0],
        indexOfDisplayedFlashcard: 1,
      ),
      initialState.copyWith(
        indexesOfRememberedFlashcards: [0],
        indexOfDisplayedFlashcard: 0,
      ),
    ],
  );
}
