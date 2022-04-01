abstract class GroupPreviewEvent {}

class GroupPreviewEventInitialize extends GroupPreviewEvent {
  final String groupId;

  GroupPreviewEventInitialize({required this.groupId});
}

class GroupPreviewEventGroupUpdated extends GroupPreviewEvent {
  final String groupId;

  GroupPreviewEventGroupUpdated({required this.groupId});
}

class GroupPreviewEventEdit extends GroupPreviewEvent {}

class GroupPreviewEventAddFlashcards extends GroupPreviewEvent {}

class GroupPreviewEventRemove extends GroupPreviewEvent {}
