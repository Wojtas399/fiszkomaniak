abstract class GroupFlashcardsPreviewEvent {}

class GroupFlashcardsPreviewEventInitialize
    extends GroupFlashcardsPreviewEvent {
  final String groupId;

  GroupFlashcardsPreviewEventInitialize({required this.groupId});
}
