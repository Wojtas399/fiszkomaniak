abstract class FlashcardsEditorEvent {}

class FlashcardsEditorEventInitialize extends FlashcardsEditorEvent {
  final String groupId;

  FlashcardsEditorEventInitialize({required this.groupId});
}
