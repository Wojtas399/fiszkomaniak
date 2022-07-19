import 'flashcards_stack_models.dart';

abstract class FlashcardsStackEvent {}

class FlashcardsStackEventInitialize extends FlashcardsStackEvent {
  final List<StackFlashcard> flashcards;

  FlashcardsStackEventInitialize({required this.flashcards});
}

class FlashcardsStackEventShowAnswer extends FlashcardsStackEvent {}

class FlashcardsStackEventMoveLeft extends FlashcardsStackEvent {}

class FlashcardsStackEventMoveRight extends FlashcardsStackEvent {}

class FlashcardsStackEventElementAnimationFinished
    extends FlashcardsStackEvent {
  final int elementIndex;

  FlashcardsStackEventElementAnimationFinished({required this.elementIndex});
}

class FlashcardsStackEventFlashcardFlipped extends FlashcardsStackEvent {}

class FlashcardsStackEventReset extends FlashcardsStackEvent {}
