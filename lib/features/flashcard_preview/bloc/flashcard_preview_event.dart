abstract class FlashcardPreviewEvent {}

class FlashcardPreviewEventInitialize extends FlashcardPreviewEvent {
  final String flashcardId;

  FlashcardPreviewEventInitialize({required this.flashcardId});
}

class FlashcardPreviewEventQuestionChanged extends FlashcardPreviewEvent {
  final String question;

  FlashcardPreviewEventQuestionChanged({required this.question});
}

class FlashcardPreviewEventAnswerChanged extends FlashcardPreviewEvent {
  final String answer;

  FlashcardPreviewEventAnswerChanged({required this.answer});
}

class FlashcardPreviewEventResetChanges extends FlashcardPreviewEvent {}

class FlashcardPreviewEventSaveChanges extends FlashcardPreviewEvent {}

class FlashcardPreviewEventRemoveFlashcard extends FlashcardPreviewEvent {}

class FlashcardPreviewEventFlashcardsStateUpdated
    extends FlashcardPreviewEvent {}
