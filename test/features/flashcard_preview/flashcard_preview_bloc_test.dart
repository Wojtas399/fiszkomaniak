import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/flashcards/remove_flashcard_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/flashcards/update_flashcard_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_bloc.dart';
import 'package:fiszkomaniak/features/flashcard_preview/flashcard_preview_dialogs.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetGroupUseCase extends Mock implements GetGroupUseCase {}

class MockGetCourseUseCase extends Mock implements GetCourseUseCase {}

class MockUpdateFlashcardUseCase extends Mock
    implements UpdateFlashcardUseCase {}

class MockRemoveFlashcardUseCase extends Mock
    implements RemoveFlashcardUseCase {}

class MockFlashcardPreviewDialogs extends Mock
    implements FlashcardPreviewDialogs {}

void main() {
  final getGroupUseCase = MockGetGroupUseCase();
  final getCourseUseCase = MockGetCourseUseCase();
  final updateFlashcardUseCase = MockUpdateFlashcardUseCase();
  final removeFlashcardUseCase = MockRemoveFlashcardUseCase();
  final flashcardPreviewDialogs = MockFlashcardPreviewDialogs();

  FlashcardPreviewBloc createBloc({
    Flashcard? flashcard,
    Group? group,
    String? courseName,
    String? question,
    String? answer,
  }) {
    return FlashcardPreviewBloc(
      getGroupUseCase: getGroupUseCase,
      getCourseUseCase: getCourseUseCase,
      updateFlashcardUseCase: updateFlashcardUseCase,
      removeFlashcardUseCase: removeFlashcardUseCase,
      flashcardPreviewDialogs: flashcardPreviewDialogs,
      flashcard: flashcard,
      group: group,
      courseName: courseName ?? '',
      question: question ?? '',
      answer: answer ?? '',
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
      status: status ?? const BlocStatusComplete<FlashcardPreviewInfoType>(),
      flashcard: flashcard,
      group: group,
      courseName: courseName ?? '',
      question: question ?? '',
      answer: answer ?? '',
    );
  }

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
        'should set group listener, should load group and course and should update the whole status',
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
            status: const BlocStatusComplete<FlashcardPreviewInfoType>(
              info:
                  FlashcardPreviewInfoType.questionAndAnswerHaveBeenInitialized,
            ),
            flashcard: flashcards[1],
            group: group,
            courseName: course.name,
            question: flashcards[1].question,
            answer: flashcards[1].answer,
          ),
        ],
        verify: (_) {
          verify(
            () => getGroupUseCase.execute(groupId: 'g1'),
          ).called(2);
          verify(
            () => getCourseUseCase.execute(courseId: 'c1'),
          ).called(1);
        },
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
          bloc.add(FlashcardPreviewEventGroupUpdated(group: group));
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
    },
  );

  blocTest(
    'question changed, should update question in state',
    build: () => createBloc(),
    act: (FlashcardPreviewBloc bloc) {
      bloc.add(FlashcardPreviewEventQuestionChanged(question: 'question'));
    },
    expect: () => [
      createState(question: 'question'),
    ],
  );

  blocTest(
    'answer changed, should update answer in state',
    build: () => createBloc(),
    act: (FlashcardPreviewBloc bloc) {
      bloc.add(FlashcardPreviewEventAnswerChanged(answer: 'answer'));
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
          bloc.add(FlashcardPreviewEventResetChanges());
        },
        expect: () => [
          createState(
            status: const BlocStatusComplete<FlashcardPreviewInfoType>(
              info: FlashcardPreviewInfoType.questionAndAnswerHaveBeenReset,
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
      bloc.add(FlashcardPreviewEventSaveChanges());
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete<FlashcardPreviewInfoType>(
          info: FlashcardPreviewInfoType.flashcardIsIncomplete,
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
        'confirmed, should call use case responsible for updating flashcard',
        build: () => createBloc(
          group: group,
          flashcard: flashcard,
          question: 'question',
          answer: 'answer',
        ),
        setUp: () {
          when(
            () => flashcardPreviewDialogs.askForSaveConfirmation(),
          ).thenAnswer((_) async => true);
          when(
            () => updateFlashcardUseCase.execute(
              groupId: 'g1',
              flashcard: flashcard.copyWith(
                question: 'question',
                answer: 'answer',
              ),
            ),
          ).thenAnswer((_) async => '');
        },
        act: (FlashcardPreviewBloc bloc) {
          bloc.add(FlashcardPreviewEventSaveChanges());
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
            status: const BlocStatusComplete<FlashcardPreviewInfoType>(
              info: FlashcardPreviewInfoType.flashcardHasBeenUpdated,
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
              groupId: 'g1',
              flashcard: flashcard.copyWith(
                question: 'question',
                answer: 'answer',
              ),
            ),
          ).called(1);
        },
      );

      blocTest(
        'cancelled, should not call use case responsible for updating flashcard',
        build: () => createBloc(
          group: group,
          flashcard: flashcard,
          question: 'question',
          answer: 'answer',
        ),
        setUp: () {
          when(
            () => flashcardPreviewDialogs.askForSaveConfirmation(),
          ).thenAnswer((_) async => false);
          when(
            () => updateFlashcardUseCase.execute(
              groupId: 'g1',
              flashcard: flashcard.copyWith(
                question: 'question',
                answer: 'answer',
              ),
            ),
          ).thenAnswer((_) async => '');
        },
        act: (FlashcardPreviewBloc bloc) {
          bloc.add(FlashcardPreviewEventSaveChanges());
        },
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => updateFlashcardUseCase.execute(
              groupId: 'g1',
              flashcard: flashcard.copyWith(
                question: 'question',
                answer: 'answer',
              ),
            ),
          );
        },
      );
    },
  );

  blocTest(
    'remove flashcard, confirmed, should call use case responsible for removing flashcard',
    build: () => createBloc(
      group: createGroup(id: 'g1'),
      flashcard: createFlashcard(index: 0),
    ),
    setUp: () {
      when(
        () => flashcardPreviewDialogs.askForDeleteConfirmation(),
      ).thenAnswer((_) async => true);
      when(
        () => removeFlashcardUseCase.execute(
          groupId: 'g1',
          flashcardIndex: 0,
        ),
      ).thenAnswer((_) async => '');
    },
    act: (FlashcardPreviewBloc bloc) {
      bloc.add(FlashcardPreviewEventRemoveFlashcard());
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        group: createGroup(id: 'g1'),
        flashcard: createFlashcard(index: 0),
      ),
      createState(
        status: const BlocStatusComplete<FlashcardPreviewInfoType>(
          info: FlashcardPreviewInfoType.flashcardHasBeenRemoved,
        ),
        group: createGroup(id: 'g1'),
        flashcard: createFlashcard(index: 0),
      ),
    ],
    verify: (_) {
      verify(
        () => removeFlashcardUseCase.execute(
          groupId: 'g1',
          flashcardIndex: 0,
        ),
      ).called(1);
    },
  );

  blocTest(
    'remove flashcard, cancelled, should not call use case responsible for removing flashcard',
    build: () => createBloc(
      group: createGroup(id: 'g1'),
      flashcard: createFlashcard(index: 0),
    ),
    setUp: () {
      when(
        () => flashcardPreviewDialogs.askForDeleteConfirmation(),
      ).thenAnswer((_) async => false);
      when(
        () => removeFlashcardUseCase.execute(
          groupId: 'g1',
          flashcardIndex: 0,
        ),
      ).thenAnswer((_) async => '');
    },
    act: (FlashcardPreviewBloc bloc) {
      bloc.add(FlashcardPreviewEventRemoveFlashcard());
    },
    expect: () => [],
    verify: (_) {
      verifyNever(
        () => removeFlashcardUseCase.execute(
          groupId: 'g1',
          flashcardIndex: 0,
        ),
      );
    },
  );
}
