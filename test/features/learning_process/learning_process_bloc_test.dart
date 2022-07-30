import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:fiszkomaniak/domain/use_cases/achievements/add_finished_session_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/flashcards/update_flashcards_statuses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/remove_session_use_case.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_bloc.dart';
import 'package:fiszkomaniak/features/learning_process/learning_process_data.dart';
import 'package:fiszkomaniak/features/learning_process/learning_process_dialogs.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

class MockGetGroupUseCase extends Mock implements GetGroupUseCase {}

class MockGetCourseUseCase extends Mock implements GetCourseUseCase {}

class MockUpdateFlashcardsStatusesUseCase extends Mock
    implements UpdateFlashcardsStatusesUseCase {}

class MockAddFinishedSessionUseCase extends Mock
    implements AddFinishedSessionUseCase {}

class MockRemoveSessionUseCase extends Mock implements RemoveSessionUseCase {}

class MockLearningProcessDialogs extends Mock
    implements LearningProcessDialogs {}

void main() {
  final getGroupUseCase = MockGetGroupUseCase();
  final getCourseUseCase = MockGetCourseUseCase();
  final updateFlashcardsStatusesUseCase = MockUpdateFlashcardsStatusesUseCase();
  final addFinishedSessionUseCase = MockAddFinishedSessionUseCase();
  final removeSessionUseCase = MockRemoveSessionUseCase();
  final learningProcessDialogs = MockLearningProcessDialogs();
  final List<Flashcard> flashcards = [
    createFlashcard(index: 0, status: FlashcardStatus.remembered),
    createFlashcard(index: 1, status: FlashcardStatus.notRemembered),
    createFlashcard(index: 2, status: FlashcardStatus.remembered),
  ];
  final Group group = createGroup(
    id: 'g1',
    courseId: 'c1',
    flashcards: flashcards,
  );
  final Course course = createCourse(id: 'c1', name: 'course name');

  LearningProcessBloc createBloc({
    String sessionId = '',
    Group? group,
    Duration? duration,
    List<Flashcard> rememberedFlashcards = const [],
    List<Flashcard> notRememberedFlashcards = const [],
    int amountOfFlashcardsInStack = 0,
    int indexOfDisplayedFlashcard = 0,
  }) {
    return LearningProcessBloc(
      getGroupUseCase: getGroupUseCase,
      getCourseUseCase: getCourseUseCase,
      updateFlashcardsStatusesUseCase: updateFlashcardsStatusesUseCase,
      addFinishedSessionUseCase: addFinishedSessionUseCase,
      removeSessionUseCase: removeSessionUseCase,
      learningProcessDialogs: learningProcessDialogs,
      sessionId: sessionId,
      group: group,
      duration: duration,
      rememberedFlashcards: rememberedFlashcards,
      notRememberedFlashcards: notRememberedFlashcards,
      amountOfFlashcardsInStack: amountOfFlashcardsInStack,
      indexOfDisplayedFlashcard: indexOfDisplayedFlashcard,
    );
  }

  LearningProcessState createState({
    BlocStatus status = const BlocStatusComplete<LearningProcessInfoType>(),
    String? sessionId,
    String courseName = '',
    Group? group,
    Duration? duration,
    bool areQuestionsAndAnswersSwapped = false,
    List<Flashcard> rememberedFlashcards = const [],
    List<Flashcard> notRememberedFlashcards = const [],
    int indexOfDisplayedFlashcard = 0,
    FlashcardsType? flashcardsType,
    int amountOfFlashcardsInStack = 0,
  }) {
    return LearningProcessState(
      status: status,
      sessionId: sessionId,
      courseName: courseName,
      group: group,
      duration: duration,
      areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
      rememberedFlashcards: rememberedFlashcards,
      notRememberedFlashcards: notRememberedFlashcards,
      indexOfDisplayedFlashcard: indexOfDisplayedFlashcard,
      flashcardsType: flashcardsType,
      amountOfFlashcardsInStack: amountOfFlashcardsInStack,
    );
  }

  tearDown(() {
    reset(getGroupUseCase);
    reset(getCourseUseCase);
    reset(updateFlashcardsStatusesUseCase);
    reset(addFinishedSessionUseCase);
    reset(removeSessionUseCase);
    reset(learningProcessDialogs);
  });

  blocTest(
    'initialize, should set params required to start session',
    build: () => createBloc(),
    setUp: () {
      when(
        () => getGroupUseCase.execute(groupId: 'g1'),
      ).thenAnswer((_) => Stream.value(group));
      when(
        () => getCourseUseCase.execute(courseId: 'c1'),
      ).thenAnswer((_) => Stream.value(course));
    },
    act: (LearningProcessBloc bloc) {
      bloc.add(
        LearningProcessEventInitialize(
          data: const LearningProcessData(
            groupId: 'g1',
            flashcardsType: FlashcardsType.all,
            areQuestionsAndAnswersSwapped: false,
            duration: Duration(minutes: 30),
            sessionId: 's1',
          ),
        ),
      );
    },
    expect: () => [
      createState(status: const BlocStatusLoading()),
      createState(
        status: const BlocStatusComplete<LearningProcessInfoType>(
          info: LearningProcessInfoType.initialDataHasBeenLoaded,
        ),
        sessionId: 's1',
        courseName: course.name,
        group: group,
        duration: const Duration(minutes: 30),
        areQuestionsAndAnswersSwapped: false,
        rememberedFlashcards: [flashcards[0], flashcards[2]],
        notRememberedFlashcards: [flashcards[1]],
        flashcardsType: FlashcardsType.all,
        amountOfFlashcardsInStack: 3,
      ),
    ],
    verify: (_) {
      verify(() => getGroupUseCase.execute(groupId: 'g1')).called(1);
      verify(() => getCourseUseCase.execute(courseId: 'c1')).called(1);
    },
  );

  blocTest(
    'remembered flashcard, should add flashcard to remembered flashcards and remove this flashcard from not remembered flashcards',
    build: () => createBloc(
      group: group,
      rememberedFlashcards: [flashcards[0], flashcards[2]],
      notRememberedFlashcards: [flashcards[1]],
      amountOfFlashcardsInStack: 3,
    ),
    act: (LearningProcessBloc bloc) {
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardIndex: 1));
    },
    expect: () => [
      createState(
        group: group,
        rememberedFlashcards: [flashcards[0], flashcards[2], flashcards[1]],
        notRememberedFlashcards: [],
        indexOfDisplayedFlashcard: 1,
        amountOfFlashcardsInStack: 3,
      ),
    ],
  );

  blocTest(
    'remembered flashcard, should not add flashcard to remembered flashcards again if this flashcard has been already added',
    build: () => createBloc(
      group: group,
      rememberedFlashcards: [flashcards[0], flashcards[2]],
      notRememberedFlashcards: [flashcards[1]],
      amountOfFlashcardsInStack: 3,
    ),
    act: (LearningProcessBloc bloc) {
      bloc.add(LearningProcessEventRememberedFlashcard(flashcardIndex: 0));
    },
    expect: () => [
      createState(
        group: group,
        rememberedFlashcards: [flashcards[0], flashcards[2]],
        notRememberedFlashcards: [flashcards[1]],
        amountOfFlashcardsInStack: 3,
        indexOfDisplayedFlashcard: 1,
      ),
    ],
  );

  blocTest(
    'forgotten flashcard, should add flashcard to not remembered flashcards and remove this flashcard from remembered flashcards',
    build: () => createBloc(
      group: group,
      rememberedFlashcards: [flashcards[0], flashcards[2]],
      notRememberedFlashcards: [flashcards[1]],
      amountOfFlashcardsInStack: 3,
    ),
    act: (LearningProcessBloc bloc) {
      bloc.add(LearningProcessEventForgottenFlashcard(flashcardIndex: 2));
    },
    expect: () => [
      createState(
        group: group,
        rememberedFlashcards: [flashcards[0]],
        notRememberedFlashcards: [flashcards[1], flashcards[2]],
        indexOfDisplayedFlashcard: 1,
        amountOfFlashcardsInStack: 3,
      ),
    ],
  );

  blocTest(
    'forgotten flashcard, should not add flashcard to not remembered flashcards if this flashcard has been already added',
    build: () => createBloc(
      group: group,
      rememberedFlashcards: [flashcards[0], flashcards[2]],
      notRememberedFlashcards: [flashcards[1]],
      amountOfFlashcardsInStack: 3,
    ),
    act: (LearningProcessBloc bloc) {
      bloc.add(LearningProcessEventForgottenFlashcard(flashcardIndex: 1));
    },
    expect: () => [
      createState(
        group: group,
        rememberedFlashcards: [flashcards[0], flashcards[2]],
        notRememberedFlashcards: [flashcards[1]],
        amountOfFlashcardsInStack: 3,
        indexOfDisplayedFlashcard: 1,
      )
    ],
  );

  blocTest(
    'reset, should reset index of displayed flashcard and should set new amount of flashcards in stack',
    build: () => createBloc(
      group: group,
      rememberedFlashcards: [flashcards[0], flashcards[2]],
      notRememberedFlashcards: [flashcards[1]],
      amountOfFlashcardsInStack: 3,
      indexOfDisplayedFlashcard: 2,
    ),
    act: (LearningProcessBloc bloc) {
      bloc.add(
        LearningProcessEventReset(
          newFlashcardsType: FlashcardsType.remembered,
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete<LearningProcessInfoType>(
          info: LearningProcessInfoType.flashcardsStackHasBeenReset,
        ),
        group: group,
        rememberedFlashcards: [flashcards[0], flashcards[2]],
        notRememberedFlashcards: [flashcards[1]],
        indexOfDisplayedFlashcard: 0,
        flashcardsType: FlashcardsType.remembered,
        amountOfFlashcardsInStack: 2,
      ),
    ],
  );

  blocTest(
    'time finished, should remove duration if user want to continue',
    build: () => createBloc(
      duration: const Duration(minutes: 30),
    ),
    setUp: () {
      when(
        () => learningProcessDialogs.askForContinuing(),
      ).thenAnswer((_) async => true);
    },
    act: (LearningProcessBloc bloc) {
      bloc.add(LearningProcessEventTimeFinished());
    },
    expect: () => [
      createState(duration: null),
    ],
    verify: (_) {
      verify(() => learningProcessDialogs.askForContinuing()).called(1);
    },
  );

  blocTest(
    'time finished, should save progress, add session to achievements and remove session',
    build: () => createBloc(
      sessionId: 's1',
      group: createGroup(id: 'g1'),
      rememberedFlashcards: [flashcards[0], flashcards[2]],
    ),
    setUp: () {
      when(
        () => learningProcessDialogs.askForContinuing(),
      ).thenAnswer(
        (_) async => false,
      );
      when(
        () => updateFlashcardsStatusesUseCase.execute(
          groupId: 'g1',
          rememberedFlashcards: [flashcards[0], flashcards[2]],
        ),
      ).thenAnswer((_) async => '');
      when(
        () => addFinishedSessionUseCase.execute(sessionId: 's1'),
      ).thenAnswer((_) async => '');
      when(
        () => removeSessionUseCase.execute(sessionId: 's1'),
      ).thenAnswer((_) async => '');
    },
    act: (LearningProcessBloc bloc) {
      bloc.add(LearningProcessEventTimeFinished());
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        sessionId: 's1',
        group: createGroup(id: 'g1'),
        rememberedFlashcards: [flashcards[0], flashcards[2]],
      ),
      createState(
        status: const BlocStatusComplete<LearningProcessInfoType>(
          info: LearningProcessInfoType.sessionHasBeenFinished,
        ),
        sessionId: 's1',
        group: createGroup(id: 'g1'),
        rememberedFlashcards: [flashcards[0], flashcards[2]],
      ),
    ],
    verify: (_) {
      verify(() => learningProcessDialogs.askForContinuing()).called(1);
      verify(
        () => updateFlashcardsStatusesUseCase.execute(
          groupId: 'g1',
          rememberedFlashcards: [flashcards[0], flashcards[2]],
        ),
      ).called(1);
      verify(
        () => addFinishedSessionUseCase.execute(sessionId: 's1'),
      ).called(1);
      verify(() => removeSessionUseCase.execute(sessionId: 's1')).called(1);
    },
  );

  blocTest(
    'end session, should save progress and remove session',
    build: () => createBloc(
      group: createGroup(id: 'g1'),
      rememberedFlashcards: [flashcards[0], flashcards[2]],
      sessionId: 's1',
    ),
    setUp: () {
      when(
        () => updateFlashcardsStatusesUseCase.execute(
          groupId: 'g1',
          rememberedFlashcards: [flashcards[0], flashcards[2]],
        ),
      ).thenAnswer((_) async => '');
      when(
        () => addFinishedSessionUseCase.execute(sessionId: 's1'),
      ).thenAnswer((_) async => '');
      when(
        () => removeSessionUseCase.execute(sessionId: 's1'),
      ).thenAnswer((_) async => '');
    },
    act: (LearningProcessBloc bloc) {
      bloc.add(LearningProcessEventEndSession());
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        group: createGroup(id: 'g1'),
        rememberedFlashcards: [flashcards[0], flashcards[2]],
        sessionId: 's1',
      ),
      createState(
        status: const BlocStatusComplete<LearningProcessInfoType>(
          info: LearningProcessInfoType.sessionHasBeenFinished,
        ),
        group: createGroup(id: 'g1'),
        rememberedFlashcards: [flashcards[0], flashcards[2]],
        sessionId: 's1',
      ),
    ],
    verify: (_) {
      verify(
        () => updateFlashcardsStatusesUseCase.execute(
          groupId: 'g1',
          rememberedFlashcards: [flashcards[0], flashcards[2]],
        ),
      ).called(1);
      verify(
        () => addFinishedSessionUseCase.execute(sessionId: 's1'),
      ).called(1);
      verify(() => removeSessionUseCase.execute(sessionId: 's1')).called(1);
    },
  );

  blocTest(
    'exit, confirmed, should save progress',
    build: () => createBloc(
      group: createGroup(id: 'g1'),
      rememberedFlashcards: [flashcards[0], flashcards[2]],
    ),
    setUp: () {
      when(
        () => learningProcessDialogs.askForSaveConfirmation(),
      ).thenAnswer((_) async => true);
      when(
        () => updateFlashcardsStatusesUseCase.execute(
          groupId: 'g1',
          rememberedFlashcards: [flashcards[0], flashcards[2]],
        ),
      ).thenAnswer((_) async => '');
    },
    act: (LearningProcessBloc bloc) {
      bloc.add(LearningProcessEventExit());
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        group: createGroup(id: 'g1'),
        rememberedFlashcards: [flashcards[0], flashcards[2]],
      ),
      createState(
        status: const BlocStatusComplete<LearningProcessInfoType>(
          info: LearningProcessInfoType.sessionHasBeenAborted,
        ),
        group: createGroup(id: 'g1'),
        rememberedFlashcards: [flashcards[0], flashcards[2]],
      ),
    ],
    verify: (_) {
      verify(() => learningProcessDialogs.askForSaveConfirmation()).called(1);
      verify(
        () => updateFlashcardsStatusesUseCase.execute(
          groupId: 'g1',
          rememberedFlashcards: [flashcards[0], flashcards[2]],
        ),
      ).called(1);
    },
  );

  blocTest(
    'exit, cancelled, should not save progress',
    build: () => createBloc(
      group: createGroup(id: 'g1'),
      rememberedFlashcards: [flashcards[0], flashcards[2]],
    ),
    setUp: () {
      when(
        () => learningProcessDialogs.askForSaveConfirmation(),
      ).thenAnswer((_) async => false);
      when(
        () => updateFlashcardsStatusesUseCase.execute(
          groupId: 'g1',
          rememberedFlashcards: [flashcards[0], flashcards[2]],
        ),
      ).thenAnswer((_) async => '');
    },
    act: (LearningProcessBloc bloc) {
      bloc.add(LearningProcessEventExit());
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete<LearningProcessInfoType>(
          info: LearningProcessInfoType.sessionHasBeenAborted,
        ),
        group: createGroup(id: 'g1'),
        rememberedFlashcards: [flashcards[0], flashcards[2]],
      ),
    ],
    verify: (_) {
      verify(() => learningProcessDialogs.askForSaveConfirmation()).called(1);
      verifyNever(
        () => updateFlashcardsStatusesUseCase.execute(
          groupId: 'g1',
          rememberedFlashcards: [flashcards[0], flashcards[2]],
        ),
      );
    },
  );
}
