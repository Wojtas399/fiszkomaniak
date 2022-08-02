part of 'group_flashcards_preview_bloc.dart';

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

class GroupFlashcardsPreviewEventGroupChanged
    extends GroupFlashcardsPreviewEvent {
  final Group group;

  GroupFlashcardsPreviewEventGroupChanged({required this.group});
}
