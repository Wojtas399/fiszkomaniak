import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_models.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_bloc.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LearningProcessState state;

  setUp(() {
    state = const LearningProcessState();
  });

  test('initial state', () {
    expect(state.status, const LearningProcessStatusInitial());
    expect(state.sessionId, null);
    expect(state.courseName, '');
    expect(state.group, null);
    expect(state.duration, null);
    expect(state.areQuestionsAndAnswersSwapped, false);
    expect(state.indexesOfRememberedFlashcards, []);
    expect(state.indexesOfNotRememberedFlashcards, []);
    expect(state.indexOfDisplayedFlashcard, 0);
    expect(state.flashcardsType, null);
    expect(state.amountOfFlashcardsInStack, 0);
  });

  test('copy with status', () {
    final LearningProcessStatus expectedStatus =
        LearningProcessStatusInProgress();

    final LearningProcessState state2 = state.copyWith(status: expectedStatus);
    final LearningProcessState state3 = state2.copyWith();

    expect(state2.status, expectedStatus);
    expect(state3.status, expectedStatus);
  });

  test('copy with session id', () {
    const String sessionId = 'session id 1';

    final LearningProcessState state2 = state.copyWith(sessionId: sessionId);
    final LearningProcessState state3 = state2.copyWith();

    expect(state2.sessionId, sessionId);
    expect(state3.sessionId, sessionId);
  });

  test('copy with courseName', () {
    const String expectedCourseName = 'course name';

    final LearningProcessState state2 = state.copyWith(
      courseName: expectedCourseName,
    );
    final LearningProcessState state3 = state2.copyWith();

    expect(state2.courseName, expectedCourseName);
    expect(state3.courseName, expectedCourseName);
  });

  test('copy with group', () {
    final Group expectedGroup = createGroup(id: 'g1', name: 'group 1');

    final LearningProcessState state2 = state.copyWith(group: expectedGroup);
    final LearningProcessState state3 = state2.copyWith();

    expect(state2.group, expectedGroup);
    expect(state3.group, expectedGroup);
  });

  test('copy with duration', () {
    const Duration expectedDuration = Duration(minutes: 10);

    final LearningProcessState state2 = state.copyWith(
      duration: expectedDuration,
    );
    final LearningProcessState state3 = state2.copyWith();

    expect(state2.duration, expectedDuration);
    expect(state3.duration, expectedDuration);
  });

  test('copy with are questions and answers swapped', () {
    const bool expectedValue = true;

    final LearningProcessState state2 = state.copyWith(
      areQuestionsAndAnswersSwapped: expectedValue,
    );
    final LearningProcessState state3 = state2.copyWith();

    expect(state2.areQuestionsAndAnswersSwapped, expectedValue);
    expect(state3.areQuestionsAndAnswersSwapped, expectedValue);
  });

  test('copy with indexes of remembered flashcards', () {
    final List<int> expectedIndexes = [1, 5];

    final LearningProcessState state2 = state.copyWith(
      indexesOfRememberedFlashcards: expectedIndexes,
    );
    final LearningProcessState state3 = state2.copyWith();

    expect(state2.indexesOfRememberedFlashcards, expectedIndexes);
    expect(state3.indexesOfRememberedFlashcards, expectedIndexes);
  });

  test('copy with indexes of not remembered flashcards', () {
    final List<int> expectedIndex = [1, 5];

    final LearningProcessState state2 = state.copyWith(
      indexesOfNotRememberedFlashcards: expectedIndex,
    );
    final LearningProcessState state3 = state2.copyWith();

    expect(state2.indexesOfNotRememberedFlashcards, expectedIndex);
    expect(state3.indexesOfNotRememberedFlashcards, expectedIndex);
  });

  test('copy with index of displayed flashcards', () {
    const int expectedIndexOfDisplayedFlashcard = 2;

    final LearningProcessState state2 = state.copyWith(
      indexOfDisplayedFlashcard: expectedIndexOfDisplayedFlashcard,
    );
    final LearningProcessState state3 = state2.copyWith();

    expect(state2.indexOfDisplayedFlashcard, expectedIndexOfDisplayedFlashcard);
    expect(state3.indexOfDisplayedFlashcard, expectedIndexOfDisplayedFlashcard);
  });

  test('copy with flashcards type', () {
    const FlashcardsType expectedFlashcardsType = FlashcardsType.remembered;

    final LearningProcessState state2 = state.copyWith(
      flashcardsType: expectedFlashcardsType,
    );
    final LearningProcessState state3 = state2.copyWith();

    expect(state2.flashcardsType, expectedFlashcardsType);
    expect(state3.flashcardsType, expectedFlashcardsType);
  });

  test('copy with amount of flashcards in stack', () {
    const int expectedAmountOfFlashcardsInStack = 4;

    final LearningProcessState state2 = state.copyWith(
      amountOfFlashcardsInStack: expectedAmountOfFlashcardsInStack,
    );
    final LearningProcessState state3 = state2.copyWith();

    expect(state2.amountOfFlashcardsInStack, expectedAmountOfFlashcardsInStack);
    expect(state3.amountOfFlashcardsInStack, expectedAmountOfFlashcardsInStack);
  });

  test('copy with removed duration', () {
    const Duration duration = Duration(minutes: 10);

    final LearningProcessState state2 = state.copyWith(duration: duration);
    final LearningProcessState state3 = state.copyWith(removedDuration: true);

    expect(state2.duration, duration);
    expect(state3.duration, null);
  });

  test('amount of remembered flashcards', () {
    state = state.copyWith(indexesOfRememberedFlashcards: [1, 4, 7]);

    expect(state.amountOfRememberedFlashcards, 3);
  });

  test('flashcards', () {
    final List<Flashcard> flashcards = [
      createFlashcard(index: 0),
      createFlashcard(index: 1),
    ];

    state = state.copyWith(group: createGroup(flashcards: flashcards));

    expect(state.flashcards, flashcards);
  });

  test('flashcards to learn, comparing by array with indexes', () {
    final List<Flashcard> flashcards = [
      createFlashcard(
        index: 0,
        question: 'q0',
        answer: 'a0',
      ),
      createFlashcard(
        index: 1,
        question: 'q1',
        answer: 'a1',
      ),
      createFlashcard(index: 2),
    ];

    state = state.copyWith(
      group: createGroup(flashcards: flashcards),
      indexesOfRememberedFlashcards: [0, 1],
      flashcardsType: FlashcardsType.remembered,
      status: LearningProcessStatusInProgress(),
    );

    expect(
      state.flashcardsToLearn,
      [
        const FlashcardInfo(index: 0, question: 'q0', answer: 'a0'),
        const FlashcardInfo(index: 1, question: 'q1', answer: 'a1'),
      ],
    );
  });

  test('amount of all flashcards', () {
    final List<Flashcard> flashcards = [
      createFlashcard(index: 0),
      createFlashcard(index: 1),
      createFlashcard(index: 2),
    ];

    state = state.copyWith(group: createGroup(flashcards: flashcards));

    expect(state.amountOfAllFlashcards, flashcards.length);
  });

  test('amount of remembered flashcards', () {
    state = state.copyWith(indexesOfRememberedFlashcards: [0, 1, 4]);

    expect(state.amountOfRememberedFlashcards, 3);
  });

  group('name for answers and questions', () {
    final Group group = createGroup(
      nameForQuestions: 'questions',
      nameForAnswers: 'answers',
    );

    test('normal order', () {
      state = state.copyWith(
        group: group,
        areQuestionsAndAnswersSwapped: false,
      );

      expect(state.nameForQuestions, group.nameForQuestions);
      expect(state.nameForAnswers, group.nameForAnswers);
    });

    test('reversed order', () {
      state = state.copyWith(
        group: group,
        areQuestionsAndAnswersSwapped: true,
      );

      expect(state.nameForQuestions, group.nameForAnswers);
      expect(state.nameForAnswers, group.nameForQuestions);
    });
  });

  group('are all flashcards remembered or not remembered', () {
    test('all flashcards remembered', () {
      final List<Flashcard> flashcards = [
        createFlashcard(index: 0),
        createFlashcard(index: 1),
      ];

      state = state.copyWith(
        group: createGroup(flashcards: flashcards),
        indexesOfRememberedFlashcards: [0, 1],
      );

      expect(state.areAllFlashcardsRememberedOrNotRemembered, true);
    });

    test('all flashcards not remembered', () {
      final List<Flashcard> flashcards = [
        createFlashcard(index: 0),
        createFlashcard(index: 1),
      ];

      state = state.copyWith(
        group: createGroup(flashcards: flashcards),
        indexesOfNotRememberedFlashcards: [0, 1],
      );

      expect(state.areAllFlashcardsRememberedOrNotRemembered, true);
    });

    test('not all flashcards are remembered or not remembered', () {
      final List<Flashcard> flashcards = [
        createFlashcard(index: 0),
        createFlashcard(index: 1),
      ];

      state = state.copyWith(
        group: createGroup(flashcards: flashcards),
        indexesOfRememberedFlashcards: [1],
        indexesOfNotRememberedFlashcards: [0],
      );

      expect(state.areAllFlashcardsRememberedOrNotRemembered, false);
    });
  });
}
