import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_status.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';

class FlashcardsState extends Equatable {
  final List<Flashcard> allFlashcards;
  final FlashcardsStatus status;

  const FlashcardsState({
    this.allFlashcards = const [],
    this.status = const FlashcardsStatusInitial(),
  });

  FlashcardsState copyWith({
    List<Flashcard>? allFlashcards,
    FlashcardsStatus? status,
  }) {
    return FlashcardsState(
      allFlashcards: allFlashcards ?? this.allFlashcards,
      status: status ?? FlashcardsStatusLoaded(),
    );
  }

  List<Flashcard> getFlashcardsFromGroup(String? groupId) {
    return allFlashcards
        .where((flashcard) => flashcard.groupId == groupId)
        .toList();
  }

  Flashcard? getFlashcardById(String flashcardId) {
    final List<Flashcard?> flashcards = [...allFlashcards];
    return flashcards.firstWhere(
      (flashcard) => flashcard?.id == flashcardId,
      orElse: () => null,
    );
  }

  @override
  List<Object> get props => [
        allFlashcards,
        status,
      ];
}
