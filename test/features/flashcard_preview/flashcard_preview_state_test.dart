import 'package:flutter_test/flutter_test.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

void main() {
  late FlashcardPreviewState state;

  setUp(
    () => state = const FlashcardPreviewState(
      status: BlocStatusInitial(),
      flashcard: null,
      group: null,
      courseName: '',
      question: '',
      answer: '',
    ),
  );

  test(
    'have question or answer been changed, should be true if new question value is different than original value',
    () {
      final Flashcard flashcard = createFlashcard(question: 'q', answer: 'a');

      state = state.copyWith(
        flashcard: flashcard,
        question: 'question',
        answer: 'a',
      );

      expect(state.haveQuestionOrAnswerBeenChanged, true);
    },
  );

  test(
    'have question or answer been changed, should be true if new answer value is different than original value',
    () {
      final Flashcard flashcard = createFlashcard(question: 'q', answer: 'a');

      state = state.copyWith(
        flashcard: flashcard,
        question: 'q',
        answer: 'answer',
      );

      expect(state.haveQuestionOrAnswerBeenChanged, true);
    },
  );

  test(
    'have question or answer been changed, should be false if new question and answer values are the same as original values',
    () {
      final Flashcard flashcard = createFlashcard(question: 'q', answer: 'a');

      state = state.copyWith(
        flashcard: flashcard,
        question: 'q',
        answer: 'a',
      );

      expect(state.haveQuestionOrAnswerBeenChanged, false);
    },
  );

  test(
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusInProgress());
    },
  );

  test(
    'copy with flashcard',
    () {
      final Flashcard expectedFlashcard = createFlashcard(
        index: 1,
        question: 'q1',
        answer: 'a1',
      );

      state = state.copyWith(flashcard: expectedFlashcard);
      final state2 = state.copyWith();

      expect(state.flashcard, expectedFlashcard);
      expect(state2.flashcard, expectedFlashcard);
    },
  );

  test(
    'copy with group',
    () {
      final Group expectedGroup = createGroup(id: 'g1', name: 'group 1');

      state = state.copyWith(group: expectedGroup);
      final state2 = state.copyWith();

      expect(state.group, expectedGroup);
      expect(state2.group, expectedGroup);
    },
  );

  test(
    'copy with course name',
    () {
      const String expectedCourseName = 'course name';

      state = state.copyWith(courseName: expectedCourseName);
      final state2 = state.copyWith();

      expect(state.courseName, expectedCourseName);
      expect(state2.courseName, expectedCourseName);
    },
  );

  test(
    'copy with question',
    () {
      const String expectedQuestion = 'question';

      state = state.copyWith(question: expectedQuestion);
      final state2 = state.copyWith();

      expect(state.question, expectedQuestion);
      expect(state2.question, expectedQuestion);
    },
  );

  test(
    'copy with answer',
    () {
      const String expectedAnswer = 'answer';

      state = state.copyWith(answer: expectedAnswer);
      final state2 = state.copyWith();

      expect(state.answer, expectedAnswer);
      expect(state2.answer, expectedAnswer);
    },
  );

  test(
    'copy with info',
    () {
      const FlashcardPreviewInfo expectedInfo =
          FlashcardPreviewInfo.flashcardHasBeenDeleted;

      state = state.copyWithInfo(expectedInfo);

      expect(
        state.status,
        const BlocStatusComplete<FlashcardPreviewInfo>(
          info: expectedInfo,
        ),
      );
    },
  );

  test(
    'copy with error',
    () {
      const FlashcardPreviewError expectedError =
          FlashcardPreviewError.flashcardIsIncomplete;

      state = state.copyWithError(expectedError);

      expect(
        state.status,
        const BlocStatusError<FlashcardPreviewError>(
          error: expectedError,
        ),
      );
    },
  );
}
