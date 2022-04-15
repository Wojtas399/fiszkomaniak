import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';

class FlashcardPreviewState extends Equatable {
  final Flashcard? flashcard;

  const FlashcardPreviewState({
    this.flashcard,
  });

  FlashcardPreviewState copyWith({
    Flashcard? flashcard,
  }) {
    return FlashcardPreviewState(
      flashcard: flashcard ?? this.flashcard,
    );
  }

  @override
  List<Object> get props => [
        flashcard ?? createFlashcard(),
      ];
}
