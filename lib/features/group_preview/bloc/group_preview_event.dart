abstract class GroupPreviewEvent {}

class GroupPreviewEventInitialize extends GroupPreviewEvent {
  final String groupId;

  GroupPreviewEventInitialize({required this.groupId});
}

class GroupPreviewEventEdit extends GroupPreviewEvent {}

class GroupPreviewEventRemove extends GroupPreviewEvent {}

class GroupPreviewEventEditFlashcards extends GroupPreviewEvent {}

class GroupPreviewEventReviewFlashcards extends GroupPreviewEvent {}

class GroupPreviewEventCreateQuickSession extends GroupPreviewEvent {}

class GroupPreviewEventGroupsStateUpdated extends GroupPreviewEvent {}

class GroupPreviewEventFlashcardsStateUpdated extends GroupPreviewEvent {}
