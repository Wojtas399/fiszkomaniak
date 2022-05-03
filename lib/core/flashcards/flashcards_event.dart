import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';

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

  FlashcardsEventSaveFlashcards({
    required this.groupId,
    required this.flashcards,
  });

  @override
  List<Object> get props => [
        groupId,
        flashcards,
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
