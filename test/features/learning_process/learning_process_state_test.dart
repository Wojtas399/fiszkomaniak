import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_models.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LearningProcessState state;

  setUp(
    () => state = const LearningProcessState(
      status: BlocStatusInitial(),
      sessionId: null,
      courseName: '',
      group: null,
      duration: null,
      areQuestionsAndAnswersSwapped: false,
      indexesOfRememberedFlashcards: [],
      indexesOfNotRememberedFlashcards: [],
      indexOfDisplayedFlashcard: 0,
      flashcardsType: null,
      amountOfFlashcardsInStack: 0,
    ),
  );

  test(
    'stack flashcards, should return empty array if flashcards type has not been set',
    () {
      expect(state.stackFlashcards, []);
    },
  );

  test(
    'stack flashcards, should return empty array if group does not have any flashcards',
    () {
      state = state.copyWith(
        group: createGroup(id: 'g1', flashcards: []),
        flashcardsType: FlashcardsType.all,
      );

      expect(state.stackFlashcards, []);
    },
  );

  test(
    'stack flashcards, should return flashcards for stack which match to flashcards type',
    () {
      final Group group = createGroup(
        id: 'g1',
        flashcards: [
          createFlashcard(
            index: 0,
            question: 'q0',
            answer: 'a0',
            status: FlashcardStatus.remembered,
          ),
          createFlashcard(
            index: 1,
            question: 'q1',
            answer: 'a1',
            status: FlashcardStatus.notRemembered,
          ),
          createFlashcard(
            index: 2,
            question: 'q2',
            answer: 'a2',
            status: FlashcardStatus.remembered,
          ),
        ],
      );
      final List<StackFlashcard> expectedStackFlashcards = [
        createStackFlashcard(
          index: 0,
          question: 'q0',
          answer: 'a0',
        ),
        createStackFlashcard(
          index: 2,
          question: 'q2',
          answer: 'a2',
        ),
      ];

      state = state.copyWith(
        group: group,
        flashcardsType: FlashcardsType.remembered,
        indexesOfRememberedFlashcards: [0, 2],
      );

      expect(state.stackFlashcards, expectedStackFlashcards);
    },
  );

  test(
    'amount of all flashcards, should return 0 if group has not been set',
    () {
      expect(state.amountOfAllFlashcards, 0);
    },
  );

  test(
    'amount of all flashcards, should return amount of all flashcards from group',
    () {
      final Group group = createGroup(
        flashcards: [
          createFlashcard(index: 0),
          createFlashcard(index: 1),
          createFlashcard(index: 2),
        ],
      );

      state = state.copyWith(group: group);

      expect(state.amountOfAllFlashcards, group.flashcards.length);
    },
  );

  test(
    'amount of remembered flashcards',
    () {
      state = state.copyWith(
        indexesOfRememberedFlashcards: [2, 5],
      );

      expect(state.amountOfRememberedFlashcards, 2);
    },
  );

  group(
    'name for questions and name for answers',
    () {
      final Group group = createGroup(
        nameForQuestions: 'questions',
        nameForAnswers: 'answers',
      );

      test(
        'name for questions should be empty string if group has not been set',
        () {
          expect(state.nameForQuestions, '');
        },
      );

      test(
        'name for answers should be empty string if group has not been set',
        () {
          expect(state.nameForAnswers, '');
        },
      );

      test(
        'name for questions should represent name for questions from group if questions name and answers name are not swapped',
        () {
          state = state.copyWith(
            group: group,
            areQuestionsAndAnswersSwapped: false,
          );

          expect(state.nameForQuestions, group.nameForQuestions);
        },
      );

      test(
        'name for questions should represent name for answers from group if questions name and answers name are swapped',
        () {
          state = state.copyWith(
            group: group,
            areQuestionsAndAnswersSwapped: true,
          );

          expect(state.nameForQuestions, group.nameForAnswers);
        },
      );

      test(
        'name for answers should represent name for answers from group if questions name and answers name are not swapped',
        () {
          state = state.copyWith(
            group: group,
            areQuestionsAndAnswersSwapped: false,
          );

          expect(state.nameForAnswers, group.nameForAnswers);
        },
      );

      test(
        'name for answers should represent name for questions if questions name and answers name are swapped',
        () {
          state = state.copyWith(
            group: group,
            areQuestionsAndAnswersSwapped: true,
          );

          expect(state.nameForAnswers, group.nameForQuestions);
        },
      );
    },
  );

  group(
    'are all flashcards remembered or not remembered',
    () {
      final Group group = createGroup(
        flashcards: [
          createFlashcard(index: 0),
          createFlashcard(index: 1),
          createFlashcard(index: 2),
        ],
      );

      test(
        'should be true if all indexes of flashcards are in array of indexes of remembered flashcards',
        () {
          state = state.copyWith(
            group: group,
            indexesOfRememberedFlashcards: [2, 1, 0],
          );

          expect(state.areAllFlashcardsRememberedOrNotRemembered, true);
        },
      );

      test(
        'should be true if all indexes of flashcards are in array of indexes of not remembered flashcards',
        () {
          state = state.copyWith(
            group: group,
            indexesOfNotRememberedFlashcards: [1, 0, 2],
          );

          expect(state.areAllFlashcardsRememberedOrNotRemembered, true);
        },
      );

      test(
        'should be false if all indexes of flashcards are not in array of indexes of remembered flashcards or in array of indexes of not remembered flashcards',
        () {
          state = state.copyWith(
            group: group,
            indexesOfRememberedFlashcards: [1, 0],
            indexesOfNotRememberedFlashcards: [2],
          );

          expect(state.areAllFlashcardsRememberedOrNotRemembered, false);
        },
      );
    },
  );

  test(
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(
        state2.status,
        const BlocStatusComplete<LearningProcessInfoType>(),
      );
    },
  );

  test(
    'copy with session id',
    () {
      const String expectedSessionId = 's1';

      state = state.copyWith(sessionId: expectedSessionId);
      final state2 = state.copyWith();

      expect(state.sessionId, expectedSessionId);
      expect(state2.sessionId, expectedSessionId);
    },
  );

  test(
    'copy with course name',
    () {
      const String expectedCourseName = 'c1';

      state = state.copyWith(courseName: expectedCourseName);
      final state2 = state.copyWith();

      expect(state.courseName, expectedCourseName);
      expect(state2.courseName, expectedCourseName);
    },
  );

  test(
    'copy with group',
    () {
      final Group expectedGroup = createGroup(id: 'g1', name: 'group name');

      state = state.copyWith(group: expectedGroup);
      final state2 = state.copyWith();

      expect(state.group, expectedGroup);
      expect(state2.group, expectedGroup);
    },
  );

  test(
    'copy with duration',
    () {
      const Duration expectedDuration = Duration(minutes: 30);

      state = state.copyWith(duration: expectedDuration);
      final state2 = state.copyWith();

      expect(state.duration, expectedDuration);
      expect(state2.duration, expectedDuration);
    },
  );

  test(
    'copy with are questions and answers swapped',
    () {
      const bool expectedValue = true;

      state = state.copyWith(areQuestionsAndAnswersSwapped: expectedValue);
      final state2 = state.copyWith();

      expect(state.areQuestionsAndAnswersSwapped, expectedValue);
      expect(state2.areQuestionsAndAnswersSwapped, expectedValue);
    },
  );

  test(
    'copy with indexes of remembered flashcards',
    () {
      const List<int> expectedIndexes = [1, 0];

      state = state.copyWith(indexesOfRememberedFlashcards: expectedIndexes);
      final state2 = state.copyWith();

      expect(state.indexesOfRememberedFlashcards, expectedIndexes);
      expect(state2.indexesOfRememberedFlashcards, expectedIndexes);
    },
  );

  test(
    'copy with indexes of not remembered flashcards',
    () {
      const List<int> expectedIndexes = [0, 2];

      state = state.copyWith(indexesOfNotRememberedFlashcards: expectedIndexes);
      final state2 = state.copyWith();

      expect(state.indexesOfNotRememberedFlashcards, expectedIndexes);
      expect(state2.indexesOfNotRememberedFlashcards, expectedIndexes);
    },
  );

  test(
    'copy with index of displayed flashcard',
    () {
      const int expectedIndex = 2;

      state = state.copyWith(indexOfDisplayedFlashcard: expectedIndex);
      final state2 = state.copyWith();

      expect(state.indexOfDisplayedFlashcard, expectedIndex);
      expect(state2.indexOfDisplayedFlashcard, expectedIndex);
    },
  );

  test(
    'copy with flashcards type',
    () {
      const FlashcardsType expectedType = FlashcardsType.remembered;

      state = state.copyWith(flashcardsType: expectedType);
      final state2 = state.copyWith();

      expect(state.flashcardsType, expectedType);
      expect(state2.flashcardsType, expectedType);
    },
  );

  test(
    'copy with amount of flashcards in stack',
    () {
      const int expectedValue = 5;

      state = state.copyWith(amountOfFlashcardsInStack: expectedValue);
      final state2 = state.copyWith();

      expect(state.amountOfFlashcardsInStack, expectedValue);
      expect(state2.amountOfFlashcardsInStack, expectedValue);
    },
  );

  test(
    'copy with removed duration',
    () {
      const Duration duration = Duration(minutes: 30);

      state = state.copyWith(duration: duration);
      final state2 = state.copyWith(removedDuration: true);

      expect(state.duration, duration);
      expect(state2.duration, null);
    },
  );
}
