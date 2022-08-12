part of 'group_preview_bloc.dart';

abstract class GroupPreviewEvent {}

class GroupPreviewEventInitialize extends GroupPreviewEvent {
  final String groupId;

  GroupPreviewEventInitialize({required this.groupId});
}

class GroupPreviewEventGroupUpdated extends GroupPreviewEvent {
  final Group group;

  GroupPreviewEventGroupUpdated({required this.group});
}

class GroupPreviewEventDeleteGroup extends GroupPreviewEvent {}
