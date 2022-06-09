import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/achievements/achievements_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:fiszkomaniak/core/user/user_bloc.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_bloc.dart';
import 'package:fiszkomaniak/features/learning_process/learning_process_data.dart';
import 'package:fiszkomaniak/features/learning_process/learning_process_dialogs.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserBloc extends Mock implements UserBloc {}

class MockCoursesBloc extends Mock implements CoursesBloc {}

class MockGroupsBloc extends Mock implements GroupsBloc {}

class MockSessionsBloc extends Mock implements SessionsBloc {}

class MockAchievementsBloc extends Mock implements AchievementsBloc {}

class MockLearningProcessDialogs extends Mock
    implements LearningProcessDialogs {}

class MockNavigation extends Mock implements Navigation {}

class FakeUserEvent extends Fake implements UserEvent {}

class FakeSessionsEvent extends Fake implements SessionsEvent {}

void main() {
  final UserBloc userBloc = MockUserBloc();
  final CoursesBloc coursesBloc = MockCoursesBloc();
  final GroupsBloc groupsBloc = MockGroupsBloc();
  final SessionsBloc sessionsBloc = MockSessionsBloc();
  final AchievementsBloc achievementsBloc = MockAchievementsBloc();
  final LearningProcessDialogs learningProcessDialogs =
      MockLearningProcessDialogs();
  final Navigation navigation = MockNavigation();
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
          createFlashcard(
            index: 0,
            question: 'q0',
            answer: 'a0',
            status: FlashcardStatus.notRemembered,
          ),
          createFlashcard(
            index: 1,
            question: 'q1',
            answer: 'a1',
            status: FlashcardStatus.notRemembered,
          ),
        ],
      ),
      createGroup(id: 'g2', courseId: 'c2'),
    ],
  );
  const LearningProcessData data = LearningProcessData(
    sessionId: 's1',
    groupId: 'g1',
    flashcardsType: FlashcardsType.all,
    areQuestionsAndAnswersSwapped: true,
    duration: Duration(minutes: 10),
  );
  final LearningProcessState initialState = LearningProcessState(
    sessionId: 's1',
    courseName: coursesState.allCourses[0].name,
    group: groupsState.allGroups[0],
    duration: const Duration(minutes: 10),
    areQuestionsAndAnswersSwapped: true,
    indexesOfNotRememberedFlashcards: const [0, 1],
    status: LearningProcessStatusLoaded(),
    flashcardsType: FlashcardsType.all,
    amountOfFlashcardsInStack: 2,
  );

  setUpAll(() {
    registerFallbackValue(FakeUserEvent());
    registerFallbackValue(FakeSessionsEvent());
  });

  setUp(() {
    bloc = LearningProcessBloc(
      userBloc: userBloc,
      coursesBloc: coursesBloc,
      groupsBloc: groupsBloc,
      sessionsBloc: sessionsBloc,
      achievementsBloc: achievementsBloc,
      learningProcessDialogs: learningProcessDialogs,
      navigation: navigation,
    );
    when(() => coursesBloc.state).thenReturn(coursesState);
    when(() => groupsBloc.state).thenReturn(groupsState);
  });

  tearDown(() {
    reset(coursesBloc);
    reset(groupsBloc);
    reset(sessionsBloc);
    reset(achievementsBloc);
    reset(learningProcessDialogs);
    reset(navigation);
  });

  blocTest(
    'initialize',
    build: () => bloc,
    act: (_) => bloc.add(LearningProcessEventInitialize(data: data)),
    expect: () => [initialState],
  );

  blocTest(
    'remembered flashcard, new',
    build: () => bloc,
    act: (_) {
      bloc.add(LearningProcessEventInitialize(data: data));
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardIndex: 0));
    },
    expect: () => [
      initialState,
      initialState.copyWith(
        indexesOfRememberedFlashcards: [0],
        indexesOfNotRememberedFlashcards: [1],
        indexOfDisplayedFlashcard: 1,
        status: LearningProcessStatusInProgress(),
      ),
    ],
  );

  blocTest(
    'remembered flashcard, existing',
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
        indexesOfNotRememberedFlashcards: [1],
        indexOfDisplayedFlashcard: 1,
        status: LearningProcessStatusInProgress(),
      ),
    ],
  );

  blocTest(
    'forgotten flashcard, new',
    build: () => bloc,
    act: (_) {
      bloc.add(LearningProcessEventInitialize(data: data));
      bloc.add(LearningProcessEventForgottenFlashcard(flashcardIndex: 2));
    },
    expect: () => [
      initialState,
      initialState.copyWith(
        indexesOfNotRememberedFlashcards: [0, 1, 2],
        indexOfDisplayedFlashcard: 1,
        status: LearningProcessStatusInProgress(),
      ),
    ],
  );

  blocTest(
    'forgotten flashcard, existing',
    build: () => bloc,
    act: (_) {
      bloc.add(LearningProcessEventInitialize(data: data));
      bloc.add(LearningProcessEventForgottenFlashcard(flashcardIndex: 2));
      bloc.add(LearningProcessEventForgottenFlashcard(flashcardIndex: 2));
    },
    expect: () => [
      initialState,
      initialState.copyWith(
        indexesOfNotRememberedFlashcards: [0, 1, 2],
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
        indexesOfNotRememberedFlashcards: [1],
        indexOfDisplayedFlashcard: 1,
        status: LearningProcessStatusInProgress(),
      ),
      initialState.copyWith(
        indexesOfRememberedFlashcards: [0],
        indexesOfNotRememberedFlashcards: [1],
        indexOfDisplayedFlashcard: 0,
        amountOfFlashcardsInStack: 1,
        flashcardsType: FlashcardsType.remembered,
        status: LearningProcessStatusReset(),
      ),
    ],
  );

  blocTest(
    'time finished, continuing confirmed',
    build: () => bloc,
    setUp: () {
      when(() => learningProcessDialogs.askForContinuing())
          .thenAnswer((_) async => true);
    },
    act: (_) {
      bloc.add(LearningProcessEventInitialize(data: data));
      bloc.add(LearningProcessEventTimeFinished());
    },
    expect: () => [
      initialState,
      initialState.copyWith(removedDuration: true),
    ],
    verify: (_) {
      verify(() => learningProcessDialogs.askForContinuing()).called(1);
    },
  );

  blocTest(
    'time finished, continuing cancelled, session with id',
    build: () => bloc,
    setUp: () {
      when(() => learningProcessDialogs.askForContinuing())
          .thenAnswer((_) async => false);
    },
    act: (_) {
      bloc.add(LearningProcessEventInitialize(
        data: createLearningProcessData(sessionId: 's1', groupId: 'g1'),
      ));
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardIndex: 0));
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardIndex: 1));
      bloc.add(LearningProcessEventTimeFinished());
    },
    verify: (_) {
      verify(() => learningProcessDialogs.askForContinuing()).called(1);
      verify(
        () => userBloc.add(UserEventSaveNewRememberedFlashcards(
          groupId: 'g1',
          rememberedFlashcardsIndexes: const [0, 1],
        )),
      ).called(1);
      verify(
        () => achievementsBloc.add(AchievementsEventAddRememberedFlashcards(
          groupId: 'g1',
          rememberedFlashcardsIndexes: const [0, 1],
        )),
      ).called(1);
      verify(
        () => achievementsBloc.add(
          AchievementsEventAddSession(sessionId: 's1'),
        ),
      ).called(1);
      verify(
        () => sessionsBloc.add(SessionsEventRemoveSession(
          sessionId: 's1',
          removeAfterLearningProcess: true,
        )),
      ).called(1);
      verify(() => navigation.moveBack()).called(1);
    },
  );

  blocTest(
    'time finished, continuing cancelled, session without id',
    build: () => bloc,
    setUp: () {
      when(() => learningProcessDialogs.askForContinuing())
          .thenAnswer((_) async => false);
    },
    act: (_) {
      bloc.add(LearningProcessEventInitialize(
        data: createLearningProcessData(groupId: 'g1'),
      ));
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardIndex: 0));
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardIndex: 1));
      bloc.add(LearningProcessEventTimeFinished());
    },
    verify: (_) {
      verify(() => learningProcessDialogs.askForContinuing()).called(1);
      verify(
        () => userBloc.add(UserEventSaveNewRememberedFlashcards(
          groupId: 'g1',
          rememberedFlashcardsIndexes: const [0, 1],
        )),
      ).called(1);
      verify(
        () => achievementsBloc.add(AchievementsEventAddRememberedFlashcards(
          groupId: 'g1',
          rememberedFlashcardsIndexes: const [0, 1],
        )),
      ).called(1);
      verify(
        () => achievementsBloc.add(AchievementsEventAddSession(sessionId: '')),
      ).called(1);
      verifyNever(() => sessionsBloc.add(any()));
      verify(() => navigation.moveBack()).called(1);
    },
  );

  blocTest(
    'end session with id',
    build: () => bloc,
    act: (_) {
      bloc.add(LearningProcessEventInitialize(
        data: createLearningProcessData(sessionId: 's1', groupId: 'g1'),
      ));
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardIndex: 0));
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardIndex: 1));
      bloc.add(LearningProcessEventEndSession());
    },
    verify: (_) {
      verify(
        () => userBloc.add(UserEventSaveNewRememberedFlashcards(
          groupId: 'g1',
          rememberedFlashcardsIndexes: const [0, 1],
        )),
      ).called(1);
      verify(
        () => achievementsBloc.add(AchievementsEventAddRememberedFlashcards(
          groupId: 'g1',
          rememberedFlashcardsIndexes: const [0, 1],
        )),
      ).called(1);
      verify(
        () => achievementsBloc.add(
          AchievementsEventAddSession(sessionId: 's1'),
        ),
      ).called(1);
      verify(
        () => sessionsBloc.add(SessionsEventRemoveSession(
          sessionId: 's1',
          removeAfterLearningProcess: true,
        )),
      ).called(1);
      verify(() => navigation.moveBack()).called(1);
    },
  );

  blocTest(
    'end session without id',
    build: () => bloc,
    act: (_) {
      bloc.add(LearningProcessEventInitialize(
        data: createLearningProcessData(groupId: 'g1'),
      ));
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardIndex: 0));
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardIndex: 1));
      bloc.add(LearningProcessEventEndSession());
    },
    verify: (_) {
      verify(
        () => userBloc.add(UserEventSaveNewRememberedFlashcards(
          groupId: 'g1',
          rememberedFlashcardsIndexes: const [0, 1],
        )),
      ).called(1);
      verify(
        () => achievementsBloc.add(AchievementsEventAddRememberedFlashcards(
          groupId: 'g1',
          rememberedFlashcardsIndexes: const [0, 1],
        )),
      ).called(1);
      verify(
        () => achievementsBloc.add(AchievementsEventAddSession(sessionId: '')),
      ).called(1);
      verifyNever(() => sessionsBloc.add(any()));
      verify(() => navigation.moveBack()).called(1);
    },
  );

  blocTest(
    'exit, save confirmed',
    build: () => bloc,
    setUp: () {
      when(() => learningProcessDialogs.askForSaveConfirmation())
          .thenAnswer((_) async => true);
    },
    act: (_) {
      bloc.add(LearningProcessEventInitialize(
        data: createLearningProcessData(sessionId: 's1', groupId: 'g1'),
      ));
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardIndex: 0));
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardIndex: 1));
      bloc.add(LearningProcessEventExit());
    },
    verify: (_) {
      verify(() => learningProcessDialogs.askForSaveConfirmation()).called(1);
      verify(
        () => userBloc.add(UserEventSaveNewRememberedFlashcards(
          groupId: 'g1',
          rememberedFlashcardsIndexes: const [0, 1],
        )),
      ).called(1);
      verify(
        () => achievementsBloc.add(AchievementsEventAddRememberedFlashcards(
          groupId: 'g1',
          rememberedFlashcardsIndexes: const [0, 1],
        )),
      ).called(1);
      verifyNever(() => sessionsBloc.add(any()));
      verify(() => navigation.moveBack()).called(1);
    },
  );

  blocTest(
    'exit, save cancelled',
    build: () => bloc,
    setUp: () {
      when(() => learningProcessDialogs.askForSaveConfirmation())
          .thenAnswer((_) async => false);
    },
    act: (_) {
      bloc.add(LearningProcessEventInitialize(
        data: createLearningProcessData(groupId: 'g1'),
      ));
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardIndex: 0));
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardIndex: 1));
      bloc.add(LearningProcessEventExit());
    },
    verify: (_) {
      verify(() => learningProcessDialogs.askForSaveConfirmation()).called(1);
      verifyNever(() => userBloc.add(any()));
      verifyNever(() => sessionsBloc.add(any()));
      verify(() => navigation.moveBack()).called(1);
    },
  );
}
