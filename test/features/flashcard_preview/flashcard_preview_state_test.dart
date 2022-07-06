import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';

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

      final state2 = state.copyWith(status: expectedStatus);
      final state3 = state2.copyWith();

      expect(state2.status, expectedStatus);
      expect(
        state3.status,
        const BlocStatusComplete<FlashcardPreviewInfoType>(),
      );
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

      final state2 = state.copyWith(flashcard: expectedFlashcard);
      final state3 = state2.copyWith();

      expect(state2.flashcard, expectedFlashcard);
      expect(state3.flashcard, expectedFlashcard);
    },
  );

  test(
    'copy with group',
    () {
      final Group expectedGroup = createGroup(id: 'g1', name: 'group 1');

      final state2 = state.copyWith(group: expectedGroup);
      final state3 = state2.copyWith();

      expect(state2.group, expectedGroup);
      expect(state3.group, expectedGroup);
    },
  );

  test(
    'copy with course name',
    () {
      const String expectedCourseName = 'course name';

      final state2 = state.copyWith(courseName: expectedCourseName);
      final state3 = state2.copyWith();

      expect(state2.courseName, expectedCourseName);
      expect(state3.courseName, expectedCourseName);
    },
  );

  test(
    'copy with question',
    () {
      const String expectedQuestion = 'question';

      final state2 = state.copyWith(question: expectedQuestion);
      final state3 = state2.copyWith();

      expect(state2.question, expectedQuestion);
      expect(state3.question, expectedQuestion);
    },
  );

  test(
    'copy with answer',
    () {
      const String expectedAnswer = 'answer';

      final state2 = state.copyWith(answer: expectedAnswer);
      final state3 = state2.copyWith();

      expect(state2.answer, expectedAnswer);
      expect(state3.answer, expectedAnswer);
    },
  );
}
