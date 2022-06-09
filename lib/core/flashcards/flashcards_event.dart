part of 'flashcards_bloc.dart';

abstract class FlashcardsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FlashcardsEventInitialize extends FlashcardsEvent {}

class FlashcardsEventGroupsStateUpdated extends FlashcardsEvent {
  final GroupsState newGroupsState;

  FlashcardsEventGroupsStateUpdated({required this.newGroupsState});
}

class FlashcardsEventSaveFlashcards extends FlashcardsEvent {
  final String groupId;
  final List<Flashcard> flashcards;
  final bool justAddedFlashcards;

  FlashcardsEventSaveFlashcards({
    required this.groupId,
    required this.flashcards,
    this.justAddedFlashcards = false,
  });

  @override
  List<Object> get props => [
        groupId,
        flashcards,
        justAddedFlashcards,
      ];
}

class FlashcardsEventUpdateFlashcard extends FlashcardsEvent {
  final String groupId;
  final Flashcard flashcard;

  FlashcardsEventUpdateFlashcard({
    required this.groupId,
    required this.flashcard,
  });

  @override
  List<Object> get props => [flashcard];
}

class FlashcardsEventRemoveFlashcard extends FlashcardsEvent {
  final String groupId;
  final Flashcard flashcard;

  FlashcardsEventRemoveFlashcard({
    required this.groupId,
    required this.flashcard,
  });

  @override
  List<Object> get props => [
        groupId,
        flashcard,
      ];
}
