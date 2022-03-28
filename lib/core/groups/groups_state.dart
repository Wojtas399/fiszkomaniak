import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'groups_status.dart';

class GroupsState extends Equatable {
  final List<Group> allGroups;
  final GroupsStatus status;

  const GroupsState({
    this.allGroups = const [],
    this.status = const GroupsStatusInitial(),
  });

  GroupsState copyWith({
    List<Group>? allGroups,
    GroupsStatus? status,
  }) {
    return GroupsState(
      allGroups: allGroups ?? this.allGroups,
      status: status ?? GroupsStatusLoaded(),
    );
  }

  Group? getGroupById(String groupId) {
    final List<Group?> groups = [...allGroups];
    return groups.firstWhere(
      (group) => group?.id == groupId,
      orElse: () => null,
    );
  }

  List<Group> getGroupsByCourseId(String courseId) {
    return allGroups.where((group) => group.courseId == courseId).toList();
  }

  @override
  List<Object> get props => [
        allGroups,
        status,
      ];
}
