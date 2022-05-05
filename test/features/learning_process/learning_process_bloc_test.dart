import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_bloc.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_event.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_state.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_status.dart';
import 'package:fiszkomaniak/features/learning_process/learning_process_data.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoursesBloc extends Mock implements CoursesBloc {}

class MockGroupsBloc extends Mock implements GroupsBloc {}

void main() {
  final CoursesBloc coursesBloc = MockCoursesBloc();
  final GroupsBloc groupsBloc = MockGroupsBloc();
  late LearningProcessBloc bloc;
  final CoursesState coursesState = CoursesState(
    allCourses: [
      createCourse(id: 'c1', name: 'course 1'),
      createCourse(id: 'c2', name: 'course 2'),
    ],
  );
  final GroupsState groupsState = GroupsState(
    allGroups: [
      createGroup(
        id: 'g1',
        courseId: 'c1',
        flashcards: [
          createFlashcard(index: 0, question: 'q0', answer: 'a0'),
          createFlashcard(index: 1, question: 'q1', answer: 'a1'),
        ],
      ),
      createGroup(id: 'g2', courseId: 'c2'),
    ],
  );
  const LearningProcessData data = LearningProcessData(
    groupId: 'g1',
    flashcardsType: FlashcardsType.all,
    areQuestionsAndAnswersSwapped: true,
  );
  final LearningProcessState initialState = LearningProcessState(
    data: const LearningProcessData(
      groupId: 'g1',
      flashcardsType: FlashcardsType.all,
      areQuestionsAndAnswersSwapped: true,
    ),
    courseName: coursesState.allCourses[0].name,
    group: groupsState.allGroups[0],
    status: LearningProcessStatusLoaded(),
    flashcardsType: FlashcardsType.all,
    amountOfFlashcardsInStack: 2,
  );

  setUp(() {
    bloc = LearningProcessBloc(
      coursesBloc: coursesBloc,
      groupsBloc: groupsBloc,
    );
    when(() => coursesBloc.state).thenReturn(coursesState);
    when(() => groupsBloc.state).thenReturn(groupsState);
  });

  tearDown(() {
    reset(coursesBloc);
    reset(groupsBloc);
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
        status: LearningProcessStatusInProgress(),
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
        status: LearningProcessStatusInProgress(),
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
        status: LearningProcessStatusInProgress(),
      ),
      initialState.copyWith(
        indexesOfRememberedFlashcards: [],
        indexOfDisplayedFlashcard: 1,
        status: LearningProcessStatusInProgress(),
      ),
    ],
  );

  blocTest(
    'reset',
    build: () => bloc,
    act: (_) {
      bloc.add(LearningProcessEventInitialize(data: data));
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardIndex: 0));
      bloc.add(LearningProcessEventReset(
        newFlashcardsType: FlashcardsType.remembered,
      ));
    },
    expect: () => [
      initialState,
      initialState.copyWith(
        indexesOfRememberedFlashcards: [0],
        indexOfDisplayedFlashcard: 1,
        status: LearningProcessStatusInProgress(),
      ),
      initialState.copyWith(
        indexesOfRememberedFlashcards: [0],
        indexOfDisplayedFlashcard: 0,
        amountOfFlashcardsInStack: 1,
        flashcardsType: FlashcardsType.remembered,
        status: LearningProcessStatusReset(),
      ),
    ],
  );
}
