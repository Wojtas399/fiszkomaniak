import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_models.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_state.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_status.dart';
import 'package:fiszkomaniak/features/learning_process/learning_process_data.dart';
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
    expect(state.data, null);
    expect(state.courseName, '');
    expect(state.group, null);
    expect(state.indexesOfRememberedFlashcards, []);
    expect(state.indexOfDisplayedFlashcard, 0);
    expect(state.flashcardsType, null);
    expect(state.amountOfFlashcardsInStack, 0);
  });

  test('copy with status', () {
    final LearningProcessStatus status = LearningProcessStatusInProgress();
    final LearningProcessState state2 = state.copyWith(status: status);
    final LearningProcessState state3 = state2.copyWith();

    expect(state2.status, status);
    expect(state3.status, status);
  });

  test('copy with data', () {
    const LearningProcessData data = LearningProcessData(
      groupId: 'g1',
      flashcardsType: FlashcardsType.remembered,
      areQuestionsAndAnswersSwapped: false,
    );
    final LearningProcessState state2 = state.copyWith(data: data);
    final LearningProcessState state3 = state2.copyWith();

    expect(state2.data, data);
    expect(state3.data, data);
  });

  test('copy with courseName', () {
    const String courseName = 'course name';
    final LearningProcessState state2 = state.copyWith(courseName: courseName);
    final LearningProcessState state3 = state2.copyWith();

    expect(state2.courseName, courseName);
    expect(state3.courseName, courseName);
  });

  test('copy with group', () {
    final Group group = createGroup(id: 'g1', name: 'group 1');
    final LearningProcessState state2 = state.copyWith(group: group);
    final LearningProcessState state3 = state2.copyWith();

    expect(state2.group, group);
    expect(state3.group, group);
  });

  test('copy with indexes of remembered flashcards', () {
    final LearningProcessState state2 = state.copyWith(
      indexesOfRememberedFlashcards: [1, 5],
    );
    final LearningProcessState state3 = state2.copyWith();

    expect(state2.indexesOfRememberedFlashcards, [1, 5]);
    expect(state3.indexesOfRememberedFlashcards, [1, 5]);
  });

  test('copy with index of displayed flashcards', () {
    const int indexOfDisplayedFlashcard = 2;
    final LearningProcessState state2 = state.copyWith(
      indexOfDisplayedFlashcard: indexOfDisplayedFlashcard,
    );
    final LearningProcessState state3 = state2.copyWith();

    expect(state2.indexOfDisplayedFlashcard, indexOfDisplayedFlashcard);
    expect(state3.indexOfDisplayedFlashcard, indexOfDisplayedFlashcard);
  });

  test('copy with flashcards type', () {
    const FlashcardsType flashcardsType = FlashcardsType.remembered;
    final LearningProcessState state2 = state.copyWith(
      flashcardsType: flashcardsType,
    );
    final LearningProcessState state3 = state2.copyWith();

    expect(state2.flashcardsType, flashcardsType);
    expect(state3.flashcardsType, flashcardsType);
  });

  test('copy with amount of flashcards in stack', () {
    const int amountOfFlashcardsInStack = 4;
    final LearningProcessState state2 = state.copyWith(
      amountOfFlashcardsInStack: amountOfFlashcardsInStack,
    );
    final LearningProcessState state3 = state2.copyWith();

    expect(state2.amountOfFlashcardsInStack, amountOfFlashcardsInStack);
    expect(state3.amountOfFlashcardsInStack, amountOfFlashcardsInStack);
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

  test('flashcards to learn, comparing by flashcard status', () {
    final List<Flashcard> flashcards = [
      createFlashcard(
        index: 0,
        status: FlashcardStatus.remembered,
        question: 'q0',
        answer: 'a0',
      ),
      createFlashcard(
        index: 1,
        status: FlashcardStatus.remembered,
        question: 'q1',
        answer: 'a1',
      ),
      createFlashcard(index: 2, status: FlashcardStatus.notRemembered),
    ];

    state = state.copyWith(
      group: createGroup(flashcards: flashcards),
      flashcardsType: FlashcardsType.remembered,
    );

    expect(
      state.flashcardsToLearn,
      [
        const FlashcardInfo(index: 0, question: 'q0', answer: 'a0'),
        const FlashcardInfo(index: 1, question: 'q1', answer: 'a1'),
      ],
    );
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
        data: createLearningProcessData(areQuestionsAndAnswersSwapped: false),
      );

      expect(state.nameForQuestions, group.nameForQuestions);
      expect(state.nameForAnswers, group.nameForAnswers);
    });

    test('reversed order', () {
      state = state.copyWith(
        group: group,
        data: createLearningProcessData(areQuestionsAndAnswersSwapped: true),
      );

      expect(state.nameForQuestions, group.nameForAnswers);
      expect(state.nameForAnswers, group.nameForQuestions);
    });
  });
}
