part of 'flashcard_preview_bloc.dart';

abstract class FlashcardPreviewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FlashcardPreviewEventInitialize extends FlashcardPreviewEvent {
  final String groupId;
  final int flashcardIndex;

  FlashcardPreviewEventInitialize({
    required this.groupId,
    required this.flashcardIndex,
  });

  @override
  List<Object> get props => [groupId, flashcardIndex];
}

class FlashcardPreviewEventGroupUpdated extends FlashcardPreviewEvent {
  final Group group;

  FlashcardPreviewEventGroupUpdated({required this.group});

  @override
  List<Object> get props => [group];
}

class FlashcardPreviewEventQuestionChanged extends FlashcardPreviewEvent {
  final String question;

  FlashcardPreviewEventQuestionChanged({required this.question});

  @override
  List<Object> get props => [question];
}

class FlashcardPreviewEventAnswerChanged extends FlashcardPreviewEvent {
  final String answer;

  FlashcardPreviewEventAnswerChanged({required this.answer});

  @override
  List<Object> get props => [answer];
}

class FlashcardPreviewEventResetChanges extends FlashcardPreviewEvent {}

class FlashcardPreviewEventSaveChanges extends FlashcardPreviewEvent {}

class FlashcardPreviewEventDeleteFlashcard extends FlashcardPreviewEvent {}
