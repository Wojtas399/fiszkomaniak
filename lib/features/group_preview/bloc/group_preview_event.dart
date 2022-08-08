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

class GroupPreviewEventGroupUpdated extends GroupPreviewEvent {
  final Group group;

  GroupPreviewEventGroupUpdated({required this.group});

  @override
  List<Object> get props => [group];
}

class GroupPreviewEventDeleteGroup extends GroupPreviewEvent {}
