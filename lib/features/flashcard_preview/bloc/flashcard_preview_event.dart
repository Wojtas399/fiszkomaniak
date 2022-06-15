part of 'flashcard_preview_bloc.dart';

abstract class FlashcardPreviewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FlashcardPreviewEventInitialize extends FlashcardPreviewEvent {
  final FlashcardPreviewParams params;

  FlashcardPreviewEventInitialize({required this.params});

  @override
  List<Object> get props => [params];
}

class FlashcardPreviewEventCourseNameUpdated extends FlashcardPreviewEvent {
  final String newCourseName;

  FlashcardPreviewEventCourseNameUpdated({required this.newCourseName});

  @override
  List<Object> get props => [newCourseName];
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

class FlashcardPreviewEventRemoveFlashcard extends FlashcardPreviewEvent {}

class FlashcardPreviewEventFlashcardsStateUpdated
    extends FlashcardPreviewEvent {}
