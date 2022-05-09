import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_status.dart';
import 'flashcards_stack_models.dart';

class FlashcardsStackState extends Equatable {
  final List<FlashcardInfo> flashcards;
  final List<AnimatedElement> animatedElements;
  final int indexOfDisplayedFlashcard;
  final FlashcardsStackStatus status;

  const FlashcardsStackState({
    this.flashcards = const [],
    this.animatedElements = const [],
    this.indexOfDisplayedFlashcard = 0,
    this.status = const FlashcardsStackStatusQuestion(),
  });

  bool get areThereUndisplayedFlashcards =>
      indexOfDisplayedFlashcard + 4 < flashcards.length;

  bool get hasLastFlashcardBeenMoved =>
      indexOfDisplayedFlashcard == flashcards.length;

  bool get isPreviewProcess =>
      status is FlashcardsStackStatusAnswer ||
      status is FlashcardsStackStatusAnswerAgain ||
      status is FlashcardsStackStatusQuestionAgain;

  FlashcardsStackState copyWith({
    List<FlashcardInfo>? flashcards,
    List<AnimatedElement>? animatedElements,
    int? indexOfDisplayedFlashcard,
    FlashcardsStackStatus? status,
  }) {
    return FlashcardsStackState(
      flashcards: flashcards ?? this.flashcards,
      animatedElements: animatedElements ?? this.animatedElements,
      indexOfDisplayedFlashcard:
          indexOfDisplayedFlashcard ?? this.indexOfDisplayedFlashcard,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        flashcards,
        animatedElements,
        indexOfDisplayedFlashcard,
        status,
      ];
}
