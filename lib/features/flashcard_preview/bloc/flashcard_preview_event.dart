abstract class FlashcardPreviewEvent {}

class FlashcardPreviewEventInitialize extends FlashcardPreviewEvent {
  final String flashcardId;

  FlashcardPreviewEventInitialize({required this.flashcardId});
}
