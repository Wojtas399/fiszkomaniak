import 'package:fiszkomaniak/core/groups/groups_state.dart';

abstract class GroupSelectionEvent {}

class GroupSelectionEventInitialize extends GroupSelectionEvent {}

class GroupSelectionEventCourseSelected extends GroupSelectionEvent {
  final String courseId;

  GroupSelectionEventCourseSelected({required this.courseId});
}

class GroupSelectionEventGroupSelected extends GroupSelectionEvent {
  final String groupId;

  GroupSelectionEventGroupSelected({required this.groupId});
}

class GroupSelectionEventButtonPressed extends GroupSelectionEvent {}

class GroupSelectionEventGroupsStateUpdated extends GroupSelectionEvent {
  final GroupsState newGroupsState;

  GroupSelectionEventGroupsStateUpdated({required this.newGroupsState});
}
