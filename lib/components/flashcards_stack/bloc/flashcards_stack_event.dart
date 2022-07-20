part of 'flashcards_stack_bloc.dart';

abstract class FlashcardsStackEvent {}

class FlashcardsStackEventInitialize extends FlashcardsStackEvent {
  final List<StackFlashcard> flashcards;

  FlashcardsStackEventInitialize({required this.flashcards});
}

class FlashcardsStackEventShowAnswer extends FlashcardsStackEvent {}

class FlashcardsStackEventMoveLeft extends FlashcardsStackEvent {}

class FlashcardsStackEventMoveRight extends FlashcardsStackEvent {}

class FlashcardsStackEventCardAnimationFinished extends FlashcardsStackEvent {
  final int movedCardIndex;

  FlashcardsStackEventCardAnimationFinished({required this.movedCardIndex});
}

class FlashcardsStackEventFlashcardFlipped extends FlashcardsStackEvent {}

class FlashcardsStackEventReset extends FlashcardsStackEvent {}
