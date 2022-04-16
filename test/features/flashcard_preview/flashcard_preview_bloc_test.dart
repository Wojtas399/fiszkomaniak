import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_event.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_state.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_bloc.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_dialogs.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_event.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_state.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_status.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoursesBloc extends Mock implements CoursesBloc {}

class MockGroupsBloc extends Mock implements GroupsBloc {}

class MockFlashcardsBloc extends Mock implements FlashcardsBloc {}

class MockFlashcardPreviewDialogs extends Mock
    implements FlashcardPreviewDialogs {}

void main() {
  final CoursesBloc coursesBloc = MockCoursesBloc();
  final GroupsBloc groupsBloc = MockGroupsBloc();
  final FlashcardsBloc flashcardsBloc = MockFlashcardsBloc();
  final FlashcardPreviewDialogs flashcardPreviewDialogs =
      MockFlashcardPreviewDialogs();
  late FlashcardPreviewBloc bloc;
  final CoursesState coursesState = CoursesState(
    allCourses: [
      createCourse(id: 'c1', name: 'course 1 name'),
      createCourse(id: 'c2', name: 'course 2 name'),
    ],
  );
  final GroupsState groupsState = GroupsState(
    allGroups: [
      createGroup(id: 'g1', courseId: 'c1'),
      createGroup(id: 'g2', courseId: 'c1'),
      createGroup(id: 'g3', courseId: 'c2'),
    ],
  );
  final FlashcardsState flashcardsState = FlashcardsState(
    allFlashcards: [
      createFlashcard(
        id: 'f1',
        groupId: 'g1',
        question: 'question',
        answer: 'answer',
      ),
      createFlashcard(id: 'f2', groupId: 'g1'),
      createFlashcard(id: 'f3', groupId: 'g3'),
    ],
  );

  setUp(() {
    bloc = FlashcardPreviewBloc(
      flashcardsBloc: flashcardsBloc,
      coursesBloc: coursesBloc,
      groupsBloc: groupsBloc,
      flashcardPreviewDialogs: flashcardPreviewDialogs,
    );
    when(() => coursesBloc.state).thenReturn(coursesState);
    when(() => groupsBloc.state).thenReturn(groupsState);
    when(() => flashcardsBloc.state).thenReturn(flashcardsState);
    when(() => flashcardsBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  tearDown(() {
    reset(coursesBloc);
    reset(groupsBloc);
    reset(flashcardsBloc);
    reset(flashcardPreviewDialogs);
  });

  blocTest(
    'initialize',
    build: () => bloc,
    act: (_) => bloc.add(FlashcardPreviewEventInitialize(flashcardId: 'f1')),
    expect: () => [
      FlashcardPreviewState(
        flashcard: flashcardsState.allFlashcards[0],
        group: groupsState.allGroups[0],
        courseName: coursesState.allCourses[0].name,
        status: FlashcardPreviewStatusLoaded(),
      ),
    ],
  );

  blocTest(
    'question changed',
    build: () => bloc,
    act: (_) => bloc.add(
      FlashcardPreviewEventQuestionChanged(question: 'question'),
    ),
    expect: () => [
      FlashcardPreviewState(
        newQuestion: 'question',
        status: FlashcardPreviewStatusQuestionChanged(),
      ),
    ],
  );

  blocTest(
    'answer changed',
    build: () => bloc,
    act: (_) => bloc.add(
      FlashcardPreviewEventAnswerChanged(answer: 'answer'),
    ),
    expect: () => [
      FlashcardPreviewState(
        newAnswer: 'answer',
        status: FlashcardPreviewStatusAnswerChanged(),
      ),
    ],
  );

  blocTest(
    'reset changes',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardPreviewEventInitialize(flashcardId: 'f1'));
      bloc.add(FlashcardPreviewEventResetChanges());
    },
    expect: () => [
      FlashcardPreviewState(
        flashcard: flashcardsState.allFlashcards[0],
        group: groupsState.allGroups[0],
        courseName: coursesState.allCourses[0].name,
        status: FlashcardPreviewStatusLoaded(),
      ),
      FlashcardPreviewState(
        flashcard: flashcardsState.allFlashcards[0],
        group: groupsState.allGroups[0],
        courseName: coursesState.allCourses[0].name,
        status: FlashcardPreviewStatusReset(),
        newQuestion: flashcardsState.allFlashcards[0].question,
        newAnswer: flashcardsState.allFlashcards[0].answer,
      ),
    ],
  );

  blocTest(
    'save changes, confirmed',
    build: () => bloc,
    setUp: () {
      when(() => flashcardPreviewDialogs.askForSaveConfirmation())
          .thenAnswer((_) async => true);
    },
    act: (_) {
      bloc.add(FlashcardPreviewEventInitialize(flashcardId: 'f1'));
      bloc.add(FlashcardPreviewEventQuestionChanged(question: 'q1'));
      bloc.add(FlashcardPreviewEventAnswerChanged(answer: 'a1'));
      bloc.add(FlashcardPreviewEventSaveChanges());
    },
    verify: (_) {
      verify(
        () => flashcardsBloc.add(FlashcardsEventUpdateFlashcard(
          flashcard: flashcardsState.allFlashcards[0].copyWith(
            question: 'q1',
            answer: 'a1',
          ),
        )),
      ).called(1);
    },
  );

  blocTest(
    'save changes, cancelled',
    build: () => bloc,
    setUp: () {
      when(() => flashcardPreviewDialogs.askForSaveConfirmation())
          .thenAnswer((_) async => false);
    },
    act: (_) {
      bloc.add(FlashcardPreviewEventInitialize(flashcardId: 'f1'));
      bloc.add(FlashcardPreviewEventQuestionChanged(question: 'q1'));
      bloc.add(FlashcardPreviewEventAnswerChanged(answer: 'a1'));
      bloc.add(FlashcardPreviewEventSaveChanges());
    },
    verify: (_) {
      verifyNever(
        () => flashcardsBloc.add(FlashcardsEventUpdateFlashcard(
          flashcard: flashcardsState.allFlashcards[0].copyWith(
            question: 'q1',
            answer: 'a1',
          ),
        )),
      );
    },
  );

  blocTest(
    'remove flashcard, confirmed',
    build: () => bloc,
    setUp: () {
      when(() => flashcardPreviewDialogs.askForDeleteConfirmation())
          .thenAnswer((_) async => true);
    },
    act: (_) {
      bloc.add(FlashcardPreviewEventInitialize(flashcardId: 'f1'));
      bloc.add(FlashcardPreviewEventRemoveFlashcard());
    },
    verify: (_) {
      verify(
        () => flashcardsBloc.add(
          FlashcardsEventRemoveFlashcard(flashcardId: 'f1'),
        ),
      ).called(1);
    },
  );

  blocTest(
    'remove flashcard, cancelled',
    build: () => bloc,
    setUp: () {
      when(() => flashcardPreviewDialogs.askForDeleteConfirmation())
          .thenAnswer((_) async => false);
    },
    act: (_) {
      bloc.add(FlashcardPreviewEventInitialize(flashcardId: 'f1'));
      bloc.add(FlashcardPreviewEventRemoveFlashcard());
    },
    verify: (_) {
      verifyNever(
        () => flashcardsBloc.add(
          FlashcardsEventRemoveFlashcard(flashcardId: 'f1'),
        ),
      );
    },
  );
}
