part of 'group_selection_bloc.dart';

abstract class GroupSelectionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GroupSelectionEventInitialize extends GroupSelectionEvent {}

class GroupSelectionEventCourseSelected extends GroupSelectionEvent {
  final String courseId;

  GroupSelectionEventCourseSelected({required this.courseId});

  @override
  List<Object> get props => [courseId];
}

class GroupSelectionEventGroupSelected extends GroupSelectionEvent {
  final String groupId;

  GroupSelectionEventGroupSelected({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

class GroupSelectionEventGroupUpdated extends GroupSelectionEvent {
  final Group group;

  GroupSelectionEventGroupUpdated({required this.group});

  @override
  List<Object> get props => [group];
}
