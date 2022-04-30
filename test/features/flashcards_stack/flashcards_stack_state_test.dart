import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_models.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_state.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FlashcardsStackState state;
  final List<FlashcardInfo> flashcards = [
    createFlashcardInfo(id: 'f1', question: 'q1', answer: 'a1'),
    createFlashcardInfo(id: 'f2', question: 'g2', answer: 'a2'),
    createFlashcardInfo(id: 'f3', question: 'q3', answer: 'a3'),
    createFlashcardInfo(id: 'f4', question: 'f4', answer: 'a4'),
    createFlashcardInfo(id: 'f5', question: 'g5', answer: 'a5'),
  ];
  final List<AnimatedElement> animatedElements = [
    createAnimatedElement(
      key: const ValueKey('el1'),
      flashcard: flashcards[0],
    ),
    createAnimatedElement(
      key: const ValueKey('el2'),
      flashcard: flashcards[1],
    ),
    createAnimatedElement(
      key: const ValueKey('el3'),
      flashcard: flashcards[2],
    ),
    createAnimatedElement(
      key: const ValueKey('el4'),
      flashcard: flashcards[3],
    ),
    createAnimatedElement(
      key: const ValueKey('el5'),
      flashcard: flashcards[4],
    ),
  ];

  setUp(() {
    state = const FlashcardsStackState();
  });

  test('initial state', () {
    expect(state.flashcards, []);
    expect(state.animatedElements, []);
    expect(state.indexOfDisplayedFlashcard, 0);
    expect(state.status, const FlashcardsStackStatusQuestion());
  });

  test('copy with flashcards', () {
    final FlashcardsStackState state2 = state.copyWith(flashcards: flashcards);
    final FlashcardsStackState state3 = state2.copyWith();

    expect(state2.flashcards, flashcards);
    expect(state3.flashcards, flashcards);
  });

  test('copy with animation elements', () {
    final FlashcardsStackState state2 = state.copyWith(
      animatedElements: animatedElements,
    );
    final FlashcardsStackState state3 = state2.copyWith();

    expect(state2.animatedElements, animatedElements);
    expect(state3.animatedElements, animatedElements);
  });

  test('copy with index of displayed flashcard', () {
    final FlashcardsStackState state2 = state.copyWith(
      indexOfDisplayedFlashcard: 4,
    );
    final FlashcardsStackState state3 = state2.copyWith();

    expect(state2.indexOfDisplayedFlashcard, 4);
    expect(state3.indexOfDisplayedFlashcard, 4);
  });

  test('copy with status', () {
    const FlashcardsStackStatus expectedStatus =
        FlashcardsStackStatusQuestion();
    final FlashcardsStackState state2 = state.copyWith(status: expectedStatus);
    final FlashcardsStackState state3 = state2.copyWith();

    expect(state2.status, expectedStatus);
    expect(state3.status, expectedStatus);
  });

  group('has last flashcard been moved', () {
    test(
      'index of displayed flashcard is equal to flashcards amount, should be true',
      () {
        final FlashcardsStackState updatedState = state.copyWith(
          flashcards: flashcards,
          indexOfDisplayedFlashcard: flashcards.length,
        );

        expect(updatedState.hasLastFlashcardBeenMoved, true);
      },
    );

    test('index of displayed flashcard is not the last, should be false', () {
      final FlashcardsStackState updatedState = state.copyWith(
        flashcards: flashcards,
        indexOfDisplayedFlashcard: 1,
      );

      expect(updatedState.hasLastFlashcardBeenMoved, false);
    });
  });

  group('are there undisplayed flashcards', () {
    test('there are undisplayed flashcards, should be true', () {
      final FlashcardsStackState updatedState = state.copyWith(
        indexOfDisplayedFlashcard: 0,
        flashcards: flashcards,
      );

      expect(updatedState.areThereUndisplayedFlashcards, true);
    });

    test('there are no undisplayed flashcards, should be false', () {
      final FlashcardsStackState updatedState = state.copyWith(
        indexOfDisplayedFlashcard: 2,
        flashcards: flashcards,
      );

      expect(updatedState.areThereUndisplayedFlashcards, false);
    });
  });

  group('is preview process', () {
    test('flashcards stack status answer, should be true', () {
      final FlashcardsStackState updatedState = state.copyWith(
        status: const FlashcardsStackStatusAnswer(),
      );

      expect(updatedState.isPreviewProcess, true);
    });

    test('flashcards stack status answer again, should be true', () {
      final FlashcardsStackState updatedState = state.copyWith(
        status: FlashcardsStackStatusAnswerAgain(),
      );

      expect(updatedState.isPreviewProcess, true);
    });

    test('flashcards stack status question again, should be true', () {
      final FlashcardsStackState updatedState = state.copyWith(
        status: FlashcardsStackStatusQuestionAgain(),
      );

      expect(updatedState.isPreviewProcess, true);
    });

    test('any other state, should be false', () {
      final FlashcardsStackState updatedState = state.copyWith(
        status: const FlashcardsStackStatusMovedRight(flashcardId: 'f1'),
      );

      expect(updatedState.isPreviewProcess, false);
    });
  });
}
