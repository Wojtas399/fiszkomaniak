import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_state.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_status.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FlashcardPreviewState state;

  setUp(() {
    state = const FlashcardPreviewState();
  });

  test('initial state', () {
    expect(state.flashcard, null);
    expect(state.group, null);
    expect(state.courseName, '');
    expect(state.newQuestion, null);
    expect(state.newAnswer, null);
    expect(state.status, const FlashcardPreviewStatusInitial());
  });

  test('copy with flashcard', () {
    final Flashcard flashcard = createFlashcard(id: 'f1');

    final FlashcardPreviewState state2 = state.copyWith(flashcard: flashcard);
    final FlashcardPreviewState state3 = state2.copyWith();

    expect(state2.flashcard, flashcard);
    expect(state3.flashcard, flashcard);
  });

  test('copy with group', () {
    final Group group = createGroup(id: 'g1');

    final FlashcardPreviewState state2 = state.copyWith(group: group);
    final FlashcardPreviewState state3 = state2.copyWith();

    expect(state2.group, group);
    expect(state3.group, group);
  });

  test('copy with course name', () {
    const String courseName = 'course name';

    final FlashcardPreviewState state2 = state.copyWith(courseName: courseName);
    final FlashcardPreviewState state3 = state2.copyWith();

    expect(state2.courseName, courseName);
    expect(state3.courseName, courseName);
  });

  test('copy with new question', () {
    const String newQuestion = 'new question';

    final FlashcardPreviewState state2 = state.copyWith(
      newQuestion: newQuestion,
    );
    final FlashcardPreviewState state3 = state2.copyWith();

    expect(state2.newQuestion, newQuestion);
    expect(state3.newQuestion, newQuestion);
  });

  test('copy with new answer', () {
    const String newAnswer = 'new answer';

    final FlashcardPreviewState state2 = state.copyWith(newAnswer: newAnswer);
    final FlashcardPreviewState state3 = state2.copyWith();

    expect(state2.newAnswer, newAnswer);
    expect(state3.newAnswer, newAnswer);
  });

  test('copy with status', () {
    final FlashcardPreviewState state2 = state.copyWith(
      status: FlashcardPreviewStatusAnswerChanged(),
    );
    final FlashcardPreviewState state3 = state2.copyWith();

    expect(state2.status, FlashcardPreviewStatusAnswerChanged());
    expect(state3.status, FlashcardPreviewStatusLoaded());
  });

  test('display save confirmation, new question and new answer as null', () {
    expect(state.displaySaveConfirmation, false);
  });

  test(
    'display save confirmation, question changed and different than original',
    () {
      final FlashcardPreviewState state2 = state.copyWith(
        flashcard: createFlashcard(question: 'question', answer: 'answer'),
      );
      final FlashcardPreviewState state3 = state2.copyWith(
        newQuestion: 'new question',
      );

      expect(state3.displaySaveConfirmation, true);
    },
  );

  test('display save confirmation, question changed and same as original', () {
    final FlashcardPreviewState state2 = state.copyWith(
      flashcard: createFlashcard(question: 'question', answer: 'answer'),
    );
    final FlashcardPreviewState state3 = state2.copyWith(
      newQuestion: 'question',
    );

    expect(state3.displaySaveConfirmation, false);
  });

  test('display save confirmation, answer changed and different than original',
      () {
    final FlashcardPreviewState state2 = state.copyWith(
      flashcard: createFlashcard(question: 'question', answer: 'answer'),
    );
    final FlashcardPreviewState state3 = state2.copyWith(
      newAnswer: 'new answer',
    );

    expect(state3.displaySaveConfirmation, true);
  });

  test('display save confirmation, answer changed and same as original', () {
    final FlashcardPreviewState state2 = state.copyWith(
      flashcard: createFlashcard(question: 'question', answer: 'answer'),
    );
    final FlashcardPreviewState state3 = state2.copyWith(
      newAnswer: 'answer',
    );

    expect(state3.displaySaveConfirmation, false);
  });
}
