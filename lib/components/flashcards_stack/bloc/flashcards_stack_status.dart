part of 'flashcards_stack_bloc.dart';

abstract class FlashcardsStackStatus extends Equatable {
  const FlashcardsStackStatus();

  @override
  List<Object> get props => [];
}

class FlashcardsStackStatusQuestion extends FlashcardsStackStatus {
  const FlashcardsStackStatusQuestion();
}

class FlashcardsStackStatusAnswer extends FlashcardsStackStatus {
  const FlashcardsStackStatusAnswer();
}

class FlashcardsStackStatusQuestionAgain extends FlashcardsStackStatus {}

class FlashcardsStackStatusAnswerAgain extends FlashcardsStackStatus {}

class FlashcardsStackStatusMovedLeft extends FlashcardsStackStatus {
  final int flashcardIndex;

  const FlashcardsStackStatusMovedLeft({required this.flashcardIndex});

  @override
  List<Object> get props => [flashcardIndex];
}

class FlashcardsStackStatusMovedRight extends FlashcardsStackStatus {
  final int flashcardIndex;

  const FlashcardsStackStatusMovedRight({required this.flashcardIndex});

  @override
  List<Object> get props => [flashcardIndex];
}

class FlashcardsStackStatusEnd extends FlashcardsStackStatus {}
