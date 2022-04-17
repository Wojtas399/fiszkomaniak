import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';

abstract class FlashcardsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FlashcardsEventInitialize extends FlashcardsEvent {}

class FlashcardsEventFlashcardAdded extends FlashcardsEvent {
  final Flashcard flashcard;

  FlashcardsEventFlashcardAdded({required this.flashcard});

  @override
  List<Object> get props => [flashcard];
}

class FlashcardsEventFlashcardUpdated extends FlashcardsEvent {
  final Flashcard flashcard;

  FlashcardsEventFlashcardUpdated({required this.flashcard});

  @override
  List<Object> get props => [flashcard];
}

class FlashcardsEventFlashcardRemoved extends FlashcardsEvent {
  final String flashcardId;

  FlashcardsEventFlashcardRemoved({required this.flashcardId});

  @override
  List<Object> get props => [flashcardId];
}

class FlashcardsEventSaveMultipleActions extends FlashcardsEvent {
  final List<Flashcard> flashcardsToUpdate;
  final List<Flashcard> flashcardsToAdd;
  final List<String> idsOfFlashcardsToRemove;

  FlashcardsEventSaveMultipleActions({
    required this.flashcardsToUpdate,
    required this.flashcardsToAdd,
    required this.idsOfFlashcardsToRemove,
  });

  @override
  List<Object> get props => [
        flashcardsToUpdate,
        flashcardsToAdd,
        idsOfFlashcardsToRemove,
      ];
}

class FlashcardsEventUpdateFlashcard extends FlashcardsEvent {
  final Flashcard flashcard;

  FlashcardsEventUpdateFlashcard({required this.flashcard});

  @override
  List<Object> get props => [flashcard];
}

class FlashcardsEventRemoveFlashcard extends FlashcardsEvent {
  final String flashcardId;

  FlashcardsEventRemoveFlashcard({required this.flashcardId});

  @override
  List<Object> get props => [flashcardId];
}