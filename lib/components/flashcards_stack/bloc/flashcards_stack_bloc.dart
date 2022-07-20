import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'flashcards_stack_animated_elements_service.dart';
import '../flashcards_stack_model.dart';

part 'flashcards_stack_event.dart';

part 'flashcards_stack_state.dart';

part 'flashcards_stack_status.dart';

class FlashcardsStackBloc
    extends Bloc<FlashcardsStackEvent, FlashcardsStackState>
    with FlashcardsStackAnimatedCardsService {
  FlashcardsStackBloc() : super(const FlashcardsStackState()) {
    on<FlashcardsStackEventInitialize>(_initialize);
    on<FlashcardsStackEventShowAnswer>(_showAnswer);
    on<FlashcardsStackEventMoveLeft>(_moveLeft);
    on<FlashcardsStackEventMoveRight>(_moveRight);
    on<FlashcardsStackEventCardAnimationFinished>(_animationFinished);
    on<FlashcardsStackEventFlashcardFlipped>(_flashcardFlipped);
    on<FlashcardsStackEventReset>(_reset);
  }

  void _initialize(
    FlashcardsStackEventInitialize event,
    Emitter<FlashcardsStackState> emit,
  ) {
    emit(state.copyWith(
      flashcards: event.flashcards,
      animatedCards: getInitialAnimatedCards(event.flashcards),
    ));
  }

  void _showAnswer(
    FlashcardsStackEventShowAnswer event,
    Emitter<FlashcardsStackState> emit,
  ) {
    emit(state.copyWith(
      status: const FlashcardsStackStatusAnswer(),
    ));
  }

  void _moveLeft(
    FlashcardsStackEventMoveLeft event,
    Emitter<FlashcardsStackState> emit,
  ) {
    _moveCardsInStack(Direction.left, emit);
  }

  void _moveRight(
    FlashcardsStackEventMoveRight event,
    Emitter<FlashcardsStackState> emit,
  ) {
    _moveCardsInStack(Direction.right, emit);
  }

  void _animationFinished(
    FlashcardsStackEventCardAnimationFinished event,
    Emitter<FlashcardsStackState> emit,
  ) {
    if (_areFlashcardsRunOut()) {
      emit(state.copyWith(
        status: FlashcardsStackStatusEnd(),
      ));
    } else if (_haveCardsInStackBeenShifted() && event.movedCardIndex == 0) {
      final List<AnimatedCard> updatedCards = moveFirstCardToTheEnd(
        state.animatedCards,
      );
      if (state.areThereUndisplayedFlashcards) {
        updatedCards.last = _assignNewStackFlashcard(updatedCards.last);
      }
      emit(state.copyWith(
        animatedCards: updatedCards,
        status: const FlashcardsStackStatusQuestion(),
      ));
    }
  }

  void _flashcardFlipped(
    FlashcardsStackEventFlashcardFlipped event,
    Emitter<FlashcardsStackState> emit,
  ) {
    final FlashcardsStackStatus status = state.status;
    if (status is FlashcardsStackStatusAnswer ||
        status is FlashcardsStackStatusAnswerAgain) {
      emit(state.copyWith(
        status: FlashcardsStackStatusQuestionAgain(),
      ));
    } else if (status is FlashcardsStackStatusQuestionAgain) {
      emit(state.copyWith(
        status: FlashcardsStackStatusAnswerAgain(),
      ));
    }
  }

  void _reset(
    FlashcardsStackEventReset event,
    Emitter<FlashcardsStackState> emit,
  ) {
    emit(state.copyWith(
      indexOfDisplayedFlashcard: 0,
      animatedCards: getInitialAnimatedCards(state.flashcards),
      status: const FlashcardsStackStatusQuestion(),
    ));
  }

  void _moveCardsInStack(
    Direction direction,
    Emitter<FlashcardsStackState> emit,
  ) {
    final List<AnimatedCard> updatedCards = moveCards(
      state.animatedCards,
      direction,
      state.areThereUndisplayedFlashcards,
    );
    final FlashcardsStackStatus status = _getStatusDependingOnMovementDirection(
      direction,
      updatedCards.first.flashcard,
    );
    emit(state.copyWith(
      animatedCards: updatedCards,
      status: status,
      indexOfDisplayedFlashcard: state.indexOfDisplayedFlashcard + 1,
    ));
  }

  bool _areFlashcardsRunOut() {
    return state.indexOfDisplayedFlashcard == state.flashcards.length;
  }

  bool _haveCardsInStackBeenShifted() {
    return state.indexOfDisplayedFlashcard > 0;
  }

  FlashcardsStackStatus _getStatusDependingOnMovementDirection(
    Direction direction,
    StackFlashcard flashcard,
  ) {
    switch (direction) {
      case Direction.left:
        return FlashcardsStackStatusMovedLeft(flashcardIndex: flashcard.index);
      case Direction.right:
        return FlashcardsStackStatusMovedRight(flashcardIndex: flashcard.index);
    }
  }

  AnimatedCard _assignNewStackFlashcard(AnimatedCard card) {
    return card.copyWith(
      flashcard: state.flashcards[state.indexOfDisplayedFlashcard + 4],
    );
  }
}
