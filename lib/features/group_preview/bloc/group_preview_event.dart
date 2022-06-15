part of 'group_preview_bloc.dart';

abstract class GroupPreviewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GroupPreviewEventInitialize extends GroupPreviewEvent {
  final String groupId;

  GroupPreviewEventInitialize({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

class GroupPreviewEventCourseNameChanged extends GroupPreviewEvent {
  final String newCourseName;

  GroupPreviewEventCourseNameChanged({required this.newCourseName});

  @override
  List<Object> get props => [newCourseName];
}

class GroupPreviewEventEdit extends GroupPreviewEvent {}

class GroupPreviewEventRemove extends GroupPreviewEvent {}

class GroupPreviewEventEditFlashcards extends GroupPreviewEvent {}

class GroupPreviewEventReviewFlashcards extends GroupPreviewEvent {}

class GroupPreviewEventCreateQuickSession extends GroupPreviewEvent {}

class GroupPreviewEventGroupsStateUpdated extends GroupPreviewEvent {}
