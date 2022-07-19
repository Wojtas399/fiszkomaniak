import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_event.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_state.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'flashcards_stack_models.dart';

class FlashcardsStackBloc
    extends Bloc<FlashcardsStackEvent, FlashcardsStackState> {
  final List<double> _scaleSteps = [1.0, 0.98, 0.96, 0.94];
  final List<double> _bottomSteps = [60.0, 45.0, 30.0, 15.0];
  final List<double> _topSteps = [30.0, 45.0, 60.0, 75.0];

  FlashcardsStackBloc() : super(const FlashcardsStackState()) {
    on<FlashcardsStackEventInitialize>(_initialize);
    on<FlashcardsStackEventShowAnswer>(_showAnswer);
    on<FlashcardsStackEventMoveLeft>(_moveLeft);
    on<FlashcardsStackEventMoveRight>(_moveRight);
    on<FlashcardsStackEventElementAnimationFinished>(_animationFinished);
    on<FlashcardsStackEventFlashcardFlipped>(_flashcardFlipped);
    on<FlashcardsStackEventReset>(_reset);
  }

  void _initialize(
    FlashcardsStackEventInitialize event,
    Emitter<FlashcardsStackState> emit,
  ) {
    emit(state.copyWith(
      flashcards: event.flashcards,
      animatedElements: _getInitialAnimatedElementsProperties(
        event.flashcards,
      ),
    ));
  }

  void _showAnswer(
    FlashcardsStackEventShowAnswer event,
    Emitter<FlashcardsStackState> emit,
  ) {
    emit(state.copyWith(status: const FlashcardsStackStatusAnswer()));
  }

  void _moveLeft(
    FlashcardsStackEventMoveLeft event,
    Emitter<FlashcardsStackState> emit,
  ) {
    _moveElement(_Direction.left, emit);
  }

  void _moveRight(
    FlashcardsStackEventMoveRight event,
    Emitter<FlashcardsStackState> emit,
  ) {
    _moveElement(_Direction.right, emit);
  }

  void _animationFinished(
    FlashcardsStackEventElementAnimationFinished event,
    Emitter<FlashcardsStackState> emit,
  ) {
    if (state.indexOfDisplayedFlashcard == state.flashcards.length) {
      emit(state.copyWith(
        status: FlashcardsStackStatusEnd(),
      ));
    } else if (state.indexOfDisplayedFlashcard > 0 && event.elementIndex == 0) {
      _updateOutsideElement(emit);
    }
  }

  void _flashcardFlipped(
    FlashcardsStackEventFlashcardFlipped event,
    Emitter<FlashcardsStackState> emit,
  ) {
    if (state.status is FlashcardsStackStatusAnswer ||
        state.status is FlashcardsStackStatusAnswerAgain) {
      emit(state.copyWith(status: FlashcardsStackStatusQuestionAgain()));
    } else if (state.status is FlashcardsStackStatusQuestionAgain) {
      emit(state.copyWith(status: FlashcardsStackStatusAnswerAgain()));
    }
  }

  void _reset(
    FlashcardsStackEventReset event,
    Emitter<FlashcardsStackState> emit,
  ) {
    emit(state.copyWith(
      indexOfDisplayedFlashcard: 0,
      animatedElements: _getInitialAnimatedElementsProperties(
        state.flashcards,
      ),
      status: const FlashcardsStackStatusQuestion(),
    ));
  }

  List<AnimatedElement> _getInitialAnimatedElementsProperties(
    List<StackFlashcard> flashcards,
  ) {
    final List<AnimatedElement> animatedElements = [];
    final int maxIndex = flashcards.length <= 4 ? flashcards.length - 1 : 4;
    for (int i = 0; i <= maxIndex; i++) {
      animatedElements.add(
        AnimatedElement(
          key: ValueKey('flashcard$i'),
          opacity: i == 4 || i == 3 ? 0.0 : 1.0,
          scale: i == 4 ? 1.0 : _scaleSteps[i],
          position: Position(
            left: i == 4 ? 424.0 : 24.0,
            right: i == 4 ? -376.0 : 24.0,
            top: _topSteps[i == 4 ? 0 : i],
            bottom: _bottomSteps[i == 4 ? 0 : i],
          ),
          flashcard: flashcards[i],
        ),
      );
    }
    return animatedElements;
  }

  void _moveElement(
    _Direction direction,
    Emitter<FlashcardsStackState> emit,
  ) {
    final List<AnimatedElement> allElements = [...state.animatedElements];
    final AnimatedElement elementToMove = allElements[0].copyWith(
      position: _getNewElementPositionDependingOnMovementDirection(
        direction,
        allElements[0].position,
      ),
    );
    final List<AnimatedElement> otherAnimatedElements = _updateElementsParams(
      allElements.getRange(1, allElements.length).toList(),
    );
    final FlashcardsStackStatus status = _getStatusDependingOnMovementDirection(
      direction,
      allElements[0].flashcard,
    );
    emit(state.copyWith(
      animatedElements: [elementToMove, ...otherAnimatedElements],
      status: status,
      indexOfDisplayedFlashcard: state.indexOfDisplayedFlashcard + 1,
    ));
  }

  void _updateOutsideElement(Emitter<FlashcardsStackState> emit) {
    final List<AnimatedElement> updatedElements = [...state.animatedElements];
    if (state.areThereUndisplayedFlashcards) {
      updatedElements[0] = updatedElements[0].copyWith(
        opacity: 0,
        flashcard: state.flashcards[state.indexOfDisplayedFlashcard + 4],
      );
    }
    emit(state.copyWith(
      animatedElements: [
        ...updatedElements.getRange(1, updatedElements.length),
        updatedElements[0],
      ],
      status: const FlashcardsStackStatusQuestion(),
    ));
  }

  List<AnimatedElement> _updateElementsParams(
    List<AnimatedElement> elements,
  ) {
    final List<AnimatedElement> updatedElements = [...elements];
    bool canResetOutsideElement = state.areThereUndisplayedFlashcards;
    for (int i = 0; i < updatedElements.length; i++) {
      double? left, right;
      if (i == updatedElements.length - 1 && canResetOutsideElement) {
        left = 24.0;
        right = 24.0;
      }
      updatedElements[i] = updatedElements[i].copyWith(
        opacity: i == 3 ? 0.0 : 1.0,
        scale: _scaleSteps[i],
        position: updatedElements[i].position.copyWith(
              top: _topSteps[i],
              bottom: _bottomSteps[i],
              left: left,
              right: right,
            ),
      );
    }
    return updatedElements;
  }

  Position _getNewElementPositionDependingOnMovementDirection(
    _Direction direction,
    Position elementPosition,
  ) {
    switch (direction) {
      case _Direction.left:
        return elementPosition.copyWith(
          left: elementPosition.left - 400,
          right: elementPosition.right + 400,
        );
      case _Direction.right:
        return elementPosition.copyWith(
          left: elementPosition.left + 400,
          right: elementPosition.right - 400,
        );
    }
  }

  FlashcardsStackStatus _getStatusDependingOnMovementDirection(
    _Direction direction,
    StackFlashcard flashcard,
  ) {
    switch (direction) {
      case _Direction.left:
        return FlashcardsStackStatusMovedLeft(flashcardIndex: flashcard.index);
      case _Direction.right:
        return FlashcardsStackStatusMovedRight(flashcardIndex: flashcard.index);
    }
  }
}

enum _Direction { left, right }
