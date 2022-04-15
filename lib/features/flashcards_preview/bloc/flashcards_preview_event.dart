abstract class FlashcardsPreviewEvent {}

class FlashcardsPreviewEventInitialize extends FlashcardsPreviewEvent {
  final String groupId;

  FlashcardsPreviewEventInitialize({required this.groupId});
}
