import 'package:equatable/equatable.dart';

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
  final String flashcardId;

  const FlashcardsStackStatusMovedLeft({required this.flashcardId});

  @override
  List<Object> get props => [flashcardId];
}

class FlashcardsStackStatusMovedRight extends FlashcardsStackStatus {
  final String flashcardId;

  const FlashcardsStackStatusMovedRight({required this.flashcardId});

  @override
  List<Object> get props => [flashcardId];
}

class FlashcardsStackStatusEnd extends FlashcardsStackStatus {}
