part of 'flashcard_preview_bloc.dart';

abstract class FlashcardPreviewEvent {}

class FlashcardPreviewEventInitialize extends FlashcardPreviewEvent {
  final String groupId;
  final int flashcardIndex;

  FlashcardPreviewEventInitialize({
    required this.groupId,
    required this.flashcardIndex,
  });
}

class FlashcardPreviewEventGroupUpdated extends FlashcardPreviewEvent {
  final Group group;

  FlashcardPreviewEventGroupUpdated({required this.group});
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

class FlashcardPreviewEventDeleteFlashcard extends FlashcardPreviewEvent {}
