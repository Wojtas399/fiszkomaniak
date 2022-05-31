part of 'groups_bloc.dart';

class GroupsState extends Equatable {
  final InitializationStatus initializationStatus;
  final List<Group> allGroups;
  final GroupsStatus status;

  const GroupsState({
    this.initializationStatus = InitializationStatus.loading,
    this.allGroups = const [],
    this.status = const GroupsStatusInitial(),
  });

  @override
  List<Object> get props => [
        initializationStatus,
        allGroups,
        status,
      ];

  List<Group> get sortedGroups {
    List<Group> sortedGroups = [...allGroups];
    sortedGroups.sort((group1, group2) => group1.name.compareTo(group2.name));
    return sortedGroups;
  }

  GroupsState copyWith({
    InitializationStatus? initializationStatus,
    List<Group>? allGroups,
    GroupsStatus? status,
  }) {
    return GroupsState(
      initializationStatus: initializationStatus ?? this.initializationStatus,
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

  String? getGroupNameById(String? groupId) {
    return getGroupById(groupId)?.name;
  }

  bool isThereGroupWithTheSameNameInTheSameCourse(
    String groupName,
    String courseId,
  ) {
    final List<Group?> groups = [...allGroups];
    final Group? matchingGroup = groups.firstWhere(
      (group) => group?.name == groupName && group?.courseId == courseId,
      orElse: () => null,
    );
    return matchingGroup != null;
  }
}
