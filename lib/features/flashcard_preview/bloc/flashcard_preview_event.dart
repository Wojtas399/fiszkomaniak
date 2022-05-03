import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_state.dart';

abstract class FlashcardPreviewEvent {}

class FlashcardPreviewEventInitialize extends FlashcardPreviewEvent {
  final FlashcardPreviewParams params;

  FlashcardPreviewEventInitialize({required this.params});
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
