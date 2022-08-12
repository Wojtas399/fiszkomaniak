import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/flashcards/delete_flashcard_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/flashcards/update_flashcard_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

class MockGetGroupUseCase extends Mock implements GetGroupUseCase {}

class MockGetCourseUseCase extends Mock implements GetCourseUseCase {}

class MockUpdateFlashcardUseCase extends Mock
    implements UpdateFlashcardUseCase {}

class MockDeleteFlashcardUseCase extends Mock
    implements DeleteFlashcardUseCase {}

class FakeFlashcard extends Fake implements Flashcard {}

void main() {
  final getGroupUseCase = MockGetGroupUseCase();
  final getCourseUseCase = MockGetCourseUseCase();
  final updateFlashcardUseCase = MockUpdateFlashcardUseCase();
  final deleteFlashcardUseCase = MockDeleteFlashcardUseCase();

  FlashcardPreviewBloc createBloc({
    BlocStatus status = const BlocStatusInitial(),
    Flashcard? flashcard,
    Group? group,
    String question = '',
    String answer = '',
  }) {
    return FlashcardPreviewBloc(
      getGroupUseCase: getGroupUseCase,
      getCourseUseCase: getCourseUseCase,
      updateFlashcardUseCase: updateFlashcardUseCase,
      deleteFlashcardUseCase: deleteFlashcardUseCase,
      status: status,
      flashcard: flashcard,
      group: group,
      question: question,
      answer: answer,
    );
  }

  FlashcardPreviewState createState({
    BlocStatus? status,
    Flashcard? flashcard,
    Group? group,
    String? courseName,
    String? question,
    String? answer,
  }) {
    return FlashcardPreviewState(
      status: status ?? const BlocStatusInProgress(),
      flashcard: flashcard,
      group: group,
      courseName: courseName ?? '',
      question: question ?? '',
      answer: answer ?? '',
    );
  }

  setUpAll(() {
    registerFallbackValue(FakeFlashcard());
  });

  tearDown(() {
    reset(getGroupUseCase);
    reset(getCourseUseCase);
    reset(updateFlashcardUseCase);
    reset(deleteFlashcardUseCase);
  });

  group(
    'initialize',
    () {
      final List<Flashcard> flashcards = [
        createFlashcard(index: 0, question: 'q0', answer: 'a0'),
        createFlashcard(index: 1, question: 'q1', answer: 'a1'),
      ];
      final Group group = createGroup(
        id: 'g1',
        courseId: 'c1',
        flashcards: flashcards,
      );
      final Course course = createCourse(id: 'c1', name: 'course 1');

      blocTest(
        'should set group listener, should load group and course name and should update the whole status',
        build: () => createBloc(),
        setUp: () {
          when(
            () => getGroupUseCase.execute(groupId: 'g1'),
          ).thenAnswer((_) => Stream.value(group));
          when(
            () => getCourseUseCase.execute(courseId: 'c1'),
          ).thenAnswer((_) => Stream.value(course));
        },
        act: (FlashcardPreviewBloc bloc) {
          bloc.add(
            FlashcardPreviewEventInitialize(groupId: 'g1', flashcardIndex: 1),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusComplete<FlashcardPreviewInfo>(
              info: FlashcardPreviewInfo.questionAndAnswerHaveBeenInitialized,
            ),
            flashcard: flashcards[1],
            group: group,
            courseName: course.name,
            question: flashcards[1].question,
            answer: flashcards[1].answer,
          ),
        ],
      );
    },
  );

  group(
    'group updated',
    () {
      final Flashcard flashcard = createFlashcard(
        index: 0,
        question: 'q0',
        answer: 'a0',
      );
      final List<Flashcard> updatedFlashcards = [
        createFlashcard(index: 0, question: 'question0', answer: 'answer0'),
        createFlashcard(index: 1, question: 'q1', answer: 'a1'),
      ];
      final Group group = createGroup(
        id: 'g1',
        name: 'group 1',
        flashcards: updatedFlashcards,
      );

      blocTest(
        'should update group, flashcard, question and answer in state',
        build: () => createBloc(flashcard: flashcard),
        act: (FlashcardPreviewBloc bloc) {
          bloc.add(
            FlashcardPreviewEventGroupUpdated(group: group),
          );
        },
        expect: () => [
          createState(
            group: group,
            flashcard: updatedFlashcards[0],
            question: updatedFlashcards[0].question,
            answer: updatedFlashcards[0].answer,
          ),
        ],
      );

      blocTest(
        'should not update group, flashcard, question and answer in state if flashcard has been deleted',
        build: () => createBloc(
          status: const BlocStatusComplete<FlashcardPreviewInfo>(
            info: FlashcardPreviewInfo.flashcardHasBeenDeleted,
          ),
          flashcard: flashcard,
        ),
        act: (FlashcardPreviewBloc bloc) {
          bloc.add(
            FlashcardPreviewEventGroupUpdated(group: group),
          );
        },
        expect: () => [],
      );
    },
  );

  blocTest(
    'question changed, should update question in state',
    build: () => createBloc(),
    act: (FlashcardPreviewBloc bloc) {
      bloc.add(
        FlashcardPreviewEventQuestionChanged(question: 'question'),
      );
    },
    expect: () => [
      createState(question: 'question'),
    ],
  );

  blocTest(
    'answer changed, should update answer in state',
    build: () => createBloc(),
    act: (FlashcardPreviewBloc bloc) {
      bloc.add(
        FlashcardPreviewEventAnswerChanged(answer: 'answer'),
      );
    },
    expect: () => [
      createState(answer: 'answer'),
    ],
  );

  group(
    'reset changes',
    () {
      final Flashcard flashcard = createFlashcard(question: 'q', answer: 'a');

      blocTest(
        'should set original question and answer in state',
        build: () => createBloc(flashcard: flashcard),
        act: (FlashcardPreviewBloc bloc) {
          bloc.add(
            FlashcardPreviewEventResetChanges(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusComplete<FlashcardPreviewInfo>(
              info: FlashcardPreviewInfo.questionAndAnswerHaveBeenReset,
            ),
            flashcard: flashcard,
            question: flashcard.question,
            answer: flashcard.answer,
          ),
        ],
      );
    },
  );

  blocTest(
    'save changes, question or answer is empty, should emit appropriate info',
    build: () => createBloc(),
    act: (FlashcardPreviewBloc bloc) {
      bloc.add(
        FlashcardPreviewEventSaveChanges(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusError<FlashcardPreviewError>(
          error: FlashcardPreviewError.flashcardIsIncomplete,
        ),
      ),
    ],
  );

  group(
    'save changes, question and answer are not empty',
    () {
      final Flashcard flashcard = createFlashcard(question: 'q', answer: 'a');
      final Group group = createGroup(id: 'g1');

      blocTest(
        'should call use case responsible for updating flashcard',
        build: () => createBloc(
          group: group,
          flashcard: flashcard,
          question: 'question',
          answer: 'answer',
        ),
        setUp: () {
          when(
            () => updateFlashcardUseCase.execute(
              groupId: group.id,
              flashcard: flashcard.copyWith(
                question: 'question',
                answer: 'answer',
              ),
            ),
          ).thenAnswer((_) async => '');
        },
        act: (FlashcardPreviewBloc bloc) {
          bloc.add(
            FlashcardPreviewEventSaveChanges(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            group: group,
            flashcard: flashcard,
            question: 'question',
            answer: 'answer',
          ),
          createState(
            status: const BlocStatusComplete<FlashcardPreviewInfo>(
              info: FlashcardPreviewInfo.flashcardHasBeenUpdated,
            ),
            group: group,
            flashcard: flashcard,
            question: 'question',
            answer: 'answer',
          ),
        ],
        verify: (_) {
          verify(
            () => updateFlashcardUseCase.execute(
              groupId: group.id,
              flashcard: flashcard.copyWith(
                question: 'question',
                answer: 'answer',
              ),
            ),
          ).called(1);
        },
      );

      blocTest(
        'should not call use case responsible for updating flashcard if group has not been set',
        build: () => createBloc(
          flashcard: flashcard,
          question: 'question',
          answer: 'answer',
        ),
        setUp: () {
          when(
            () => updateFlashcardUseCase.execute(
              groupId: any(named: 'groupId'),
              flashcard: flashcard.copyWith(
                question: 'question',
                answer: 'answer',
              ),
            ),
          ).thenAnswer((_) async => '');
        },
        act: (FlashcardPreviewBloc bloc) {
          bloc.add(
            FlashcardPreviewEventSaveChanges(),
          );
        },
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => updateFlashcardUseCase.execute(
              groupId: any(named: 'groupId'),
              flashcard: flashcard.copyWith(
                question: 'question',
                answer: 'answer',
              ),
            ),
          );
        },
      );

      blocTest(
        'should not call use case responsible for updating flashcard if flashcard has not been set',
        build: () => createBloc(
          group: group,
          question: 'question',
          answer: 'answer',
        ),
        setUp: () {
          when(
            () => updateFlashcardUseCase.execute(
              groupId: group.id,
              flashcard: any(named: 'flashcard'),
            ),
          ).thenAnswer((_) async => '');
        },
        act: (FlashcardPreviewBloc bloc) {
          bloc.add(
            FlashcardPreviewEventSaveChanges(),
          );
        },
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => updateFlashcardUseCase.execute(
              groupId: group.id,
              flashcard: any(named: 'flashcard'),
            ),
          );
        },
      );
    },
  );

  blocTest(
    'delete flashcard, should call use case responsible for deleting flashcard',
    build: () => createBloc(
      group: createGroup(id: 'g1'),
      flashcard: createFlashcard(index: 0),
    ),
    setUp: () {
      when(
        () => deleteFlashcardUseCase.execute(
          groupId: 'g1',
          flashcardIndex: 0,
        ),
      ).thenAnswer((_) async => '');
    },
    act: (FlashcardPreviewBloc bloc) {
      bloc.add(
        FlashcardPreviewEventDeleteFlashcard(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        group: createGroup(id: 'g1'),
        flashcard: createFlashcard(index: 0),
      ),
      createState(
        status: const BlocStatusComplete<FlashcardPreviewInfo>(
          info: FlashcardPreviewInfo.flashcardHasBeenDeleted,
        ),
        group: createGroup(id: 'g1'),
        flashcard: createFlashcard(index: 0),
      ),
    ],
    verify: (_) {
      verify(
        () => deleteFlashcardUseCase.execute(
          groupId: 'g1',
          flashcardIndex: 0,
        ),
      ).called(1);
    },
  );

  blocTest(
    'delete flashcard, should not call use case responsible for deleting flashcard if group has not been set',
    build: () => createBloc(
      flashcard: createFlashcard(index: 0),
    ),
    setUp: () {
      when(
        () => deleteFlashcardUseCase.execute(
          groupId: any(named: 'groupId'),
          flashcardIndex: 0,
        ),
      ).thenAnswer((_) async => '');
    },
    act: (FlashcardPreviewBloc bloc) {
      bloc.add(
        FlashcardPreviewEventDeleteFlashcard(),
      );
    },
    expect: () => [],
    verify: (_) {
      verifyNever(
        () => deleteFlashcardUseCase.execute(
          groupId: any(named: 'groupId'),
          flashcardIndex: 0,
        ),
      );
    },
  );

  blocTest(
    'delete flashcard, should not call use case responsible for deleting flashcard if flashcard has not been set',
    build: () => createBloc(
      group: createGroup(id: 'g1'),
    ),
    setUp: () {
      when(
        () => deleteFlashcardUseCase.execute(
          groupId: 'g1',
          flashcardIndex: any(named: 'flashcardIndex'),
        ),
      ).thenAnswer((_) async => '');
    },
    act: (FlashcardPreviewBloc bloc) {
      bloc.add(
        FlashcardPreviewEventDeleteFlashcard(),
      );
    },
    expect: () => [],
    verify: (_) {
      verifyNever(
        () => deleteFlashcardUseCase.execute(
          groupId: 'g1',
          flashcardIndex: any(named: 'flashcardIndex'),
        ),
      );
    },
  );
}
