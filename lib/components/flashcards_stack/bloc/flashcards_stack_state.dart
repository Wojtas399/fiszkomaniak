part of 'flashcards_stack_bloc.dart';

class FlashcardsStackState extends Equatable {
  final List<StackFlashcard> flashcards;
  final List<AnimatedCard> animatedCards;
  final int indexOfDisplayedFlashcard;
  final FlashcardsStackStatus status;

  const FlashcardsStackState({
    this.flashcards = const [],
    this.animatedCards = const [],
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
    List<StackFlashcard>? flashcards,
    List<AnimatedCard>? animatedCards,
    int? indexOfDisplayedFlashcard,
    FlashcardsStackStatus? status,
  }) {
    return FlashcardsStackState(
      flashcards: flashcards ?? this.flashcards,
      animatedCards: animatedCards ?? this.animatedCards,
      indexOfDisplayedFlashcard:
          indexOfDisplayedFlashcard ?? this.indexOfDisplayedFlashcard,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        flashcards,
        animatedCards,
        indexOfDisplayedFlashcard,
        status,
      ];
}
