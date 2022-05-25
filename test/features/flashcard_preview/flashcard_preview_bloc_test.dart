import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
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
      createGroup(
        id: 'g1',
        courseId: 'c1',
        flashcards: [
          createFlashcard(index: 0, question: 'q1', answer: 'a1'),
          createFlashcard(index: 1, question: 'q2', answer: 'a2'),
          createFlashcard(index: 2, question: 'q3', answer: 'a3'),
        ],
      ),
      createGroup(id: 'g2', courseId: 'c1'),
      createGroup(id: 'g3', courseId: 'c2'),
    ],
  );
  final FlashcardsState flashcardsState = FlashcardsState(
    groupsState: groupsState,
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
    act: (_) => bloc.add(FlashcardPreviewEventInitialize(
      params: FlashcardPreviewParams(groupId: 'g1', flashcardIndex: 1),
    )),
    expect: () => [
      FlashcardPreviewState(
        flashcard: groupsState.allGroups[0].flashcards[1],
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
      bloc.add(FlashcardPreviewEventInitialize(
        params: FlashcardPreviewParams(groupId: 'g1', flashcardIndex: 0),
      ));
      bloc.add(FlashcardPreviewEventResetChanges());
    },
    expect: () => [
      FlashcardPreviewState(
        flashcard: groupsState.allGroups[0].flashcards[0],
        group: groupsState.allGroups[0],
        courseName: coursesState.allCourses[0].name,
        status: FlashcardPreviewStatusLoaded(),
      ),
      FlashcardPreviewState(
        flashcard: groupsState.allGroups[0].flashcards[0],
        group: groupsState.allGroups[0],
        courseName: coursesState.allCourses[0].name,
        status: FlashcardPreviewStatusReset(),
        newQuestion: groupsState.allGroups[0].flashcards[0].question,
        newAnswer: groupsState.allGroups[0].flashcards[0].answer,
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
      bloc.add(FlashcardPreviewEventInitialize(
        params: FlashcardPreviewParams(groupId: 'g1', flashcardIndex: 0),
      ));
      bloc.add(FlashcardPreviewEventQuestionChanged(question: 'q1'));
      bloc.add(FlashcardPreviewEventAnswerChanged(answer: 'a1'));
      bloc.add(FlashcardPreviewEventSaveChanges());
    },
    verify: (_) {
      verify(() => flashcardPreviewDialogs.askForSaveConfirmation()).called(1);
      verify(
        () => flashcardsBloc.add(FlashcardsEventUpdateFlashcard(
          groupId: 'g1',
          flashcard: groupsState.allGroups[0].flashcards[0].copyWith(
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
      bloc.add(FlashcardPreviewEventInitialize(
        params: FlashcardPreviewParams(groupId: 'g1', flashcardIndex: 0),
      ));
      bloc.add(FlashcardPreviewEventQuestionChanged(question: 'q1'));
      bloc.add(FlashcardPreviewEventAnswerChanged(answer: 'a1'));
      bloc.add(FlashcardPreviewEventSaveChanges());
    },
    verify: (_) {
      verify(() => flashcardPreviewDialogs.askForSaveConfirmation()).called(1);
      verifyNever(
        () => flashcardsBloc.add(FlashcardsEventUpdateFlashcard(
          groupId: 'g1',
          flashcard: groupsState.allGroups[0].flashcards[0].copyWith(
            question: 'q1',
            answer: 'a1',
          ),
        )),
      );
    },
  );

  blocTest(
    'save changes, new answer is empty',
    build: () => bloc,
    setUp: () {
      when(() => flashcardPreviewDialogs.showEmptyFlashcardInfo())
          .thenAnswer((_) async => '');
    },
    act: (_) {
      bloc.add(FlashcardPreviewEventInitialize(
        params: FlashcardPreviewParams(groupId: 'g1', flashcardIndex: 0),
      ));
      bloc.add(FlashcardPreviewEventQuestionChanged(question: 'q1'));
      bloc.add(FlashcardPreviewEventAnswerChanged(answer: ''));
      bloc.add(FlashcardPreviewEventSaveChanges());
    },
    verify: (_) {
      verify(() => flashcardPreviewDialogs.showEmptyFlashcardInfo()).called(1);
      verifyNever(
        () => flashcardsBloc.add(FlashcardsEventUpdateFlashcard(
          groupId: 'g1',
          flashcard: groupsState.allGroups[0].flashcards[0].copyWith(
            question: 'q1',
            answer: '',
          ),
        )),
      );
    },
  );

  blocTest(
    'save changes, new question is empty',
    build: () => bloc,
    setUp: () {
      when(() => flashcardPreviewDialogs.showEmptyFlashcardInfo())
          .thenAnswer((_) async => '');
    },
    act: (_) {
      bloc.add(FlashcardPreviewEventInitialize(
        params: FlashcardPreviewParams(groupId: 'g1', flashcardIndex: 0),
      ));
      bloc.add(FlashcardPreviewEventQuestionChanged(question: ''));
      bloc.add(FlashcardPreviewEventAnswerChanged(answer: 'a1'));
      bloc.add(FlashcardPreviewEventSaveChanges());
    },
    verify: (_) {
      verify(() => flashcardPreviewDialogs.showEmptyFlashcardInfo()).called(1);
      verifyNever(
        () => flashcardsBloc.add(FlashcardsEventUpdateFlashcard(
          groupId: 'g1',
          flashcard: groupsState.allGroups[0].flashcards[0].copyWith(
            question: '',
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
      bloc.add(FlashcardPreviewEventInitialize(
        params: FlashcardPreviewParams(groupId: 'g1', flashcardIndex: 0),
      ));
      bloc.add(FlashcardPreviewEventRemoveFlashcard());
    },
    verify: (_) {
      verify(() => flashcardPreviewDialogs.askForDeleteConfirmation())
          .called(1);
      verify(
        () => flashcardsBloc.add(
          FlashcardsEventRemoveFlashcard(
            groupId: 'g1',
            flashcard: groupsState.allGroups[0].flashcards[0],
          ),
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
      bloc.add(FlashcardPreviewEventInitialize(
        params: FlashcardPreviewParams(groupId: 'g1', flashcardIndex: 0),
      ));
      bloc.add(FlashcardPreviewEventRemoveFlashcard());
    },
    verify: (_) {
      verify(() => flashcardPreviewDialogs.askForDeleteConfirmation())
          .called(1);
      verifyNever(
        () => flashcardsBloc.add(
          FlashcardsEventRemoveFlashcard(
            groupId: 'g1',
            flashcard: groupsState.allGroups[0].flashcards[0],
          ),
        ),
      );
    },
  );
}
