part of 'course_groups_preview_bloc.dart';

class CourseGroupsPreviewState extends Equatable {
  final String courseName;
  final String searchValue;
  final List<Group> groupsFromCourse;

  const CourseGroupsPreviewState({
    required this.courseName,
    required this.searchValue,
    required this.groupsFromCourse,
  });

  @override
  List<Object> get props => [
        courseName,
        searchValue,
        groupsFromCourse,
      ];

  List<Group> get groupsFromCourseMatchingToSearchValue {
    final List<Group> matchingGroups = groupsFromCourse
        .where(
          (group) => group.name.toLowerCase().contains(
                searchValue.toLowerCase(),
              ),
        )
        .toList();
    matchingGroups.sort(_setGroupsAlphabeticallyByName);
    return matchingGroups;
  }

  bool get areGroupsInCourse => groupsFromCourse.isNotEmpty;

  CourseGroupsPreviewState copyWith({
    String? courseName,
    String? searchValue,
    List<Group>? groupsFromCourse,
  }) {
    return CourseGroupsPreviewState(
      courseName: courseName ?? this.courseName,
      searchValue: searchValue ?? this.searchValue,
      groupsFromCourse: groupsFromCourse ?? this.groupsFromCourse,
    );
  }

  int _setGroupsAlphabeticallyByName(
    Group group1,
    Group group2,
  ) {
    return group1.name.compareTo(group2.name);
  }
}

class CourseGroupsPreviewStateListenedParams extends Equatable {
  final String courseName;
  final List<Group> groupsFromCourse;

  const CourseGroupsPreviewStateListenedParams({
    required this.courseName,
    required this.groupsFromCourse,
  });

  @override
  List<Object> get props => [
        courseName,
        groupsFromCourse,
      ];
}
