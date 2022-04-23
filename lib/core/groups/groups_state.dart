import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'groups_status.dart';

class GroupsState extends Equatable {
  late final List<Group> _allGroups;
  final GroupsStatus status;

  List<Group> get allGroups {
    List<Group> sortedGroups = [..._allGroups];
    sortedGroups.sort((group1, group2) => group1.name.compareTo(group2.name));
    return sortedGroups;
  }

  GroupsState({
    List<Group> allGroups = const [],
    this.status = const GroupsStatusInitial(),
  }) {
    _allGroups = allGroups;
  }

  GroupsState copyWith({
    List<Group>? allGroups,
    GroupsStatus? status,
  }) {
    return GroupsState(
      allGroups: allGroups ?? this.allGroups,
      status: status ?? GroupsStatusLoaded(),
    );
  }

  Group? getGroupById(String? groupId) {
    final List<Group?> groups = [...allGroups];
    return groups.firstWhere(
      (group) => group?.id == groupId,
      orElse: () => null,
    );
  }

  List<Group> getGroupsByCourseId(String? courseId) {
    return allGroups.where((group) => group.courseId == courseId).toList();
  }

  List<String> getGroupsIdsByCourseId(String courseId) {
    return getGroupsByCourseId(courseId).map((group) => group.id).toList();
  }

  String? getGroupNameById(String groupId) {
    return getGroupById(groupId)?.name;
  }

  @override
  List<Object> get props => [
        allGroups,
        status,
      ];
}
