abstract class GroupFlashcardsPreviewEvent {}

class GroupFlashcardsPreviewEventInitialize
    extends GroupFlashcardsPreviewEvent {
  final String groupId;

  GroupFlashcardsPreviewEventInitialize({required this.groupId});
}

class GroupFlashcardsPreviewEventSearchValueChanged
    extends GroupFlashcardsPreviewEvent {
  final String searchValue;

  GroupFlashcardsPreviewEventSearchValueChanged({required this.searchValue});
}

class GroupFlashcardsPreviewEventFlashcardsStateUpdated
    extends GroupFlashcardsPreviewEvent {}
