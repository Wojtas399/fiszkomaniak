part of 'course_groups_preview_bloc.dart';

class CourseGroupsPreviewState extends Equatable {
  final String courseName;
  final String searchValue;
  late final List<GroupItemParams> _groupsFromCourse;

  CourseGroupsPreviewState({
    this.courseName = '',
    this.searchValue = '',
    List<GroupItemParams> groupsFromCourse = const [],
  }) {
    _groupsFromCourse = groupsFromCourse;
  }

  @override
  List<Object> get props => [
        courseName,
        searchValue,
        _groupsFromCourse,
      ];

  List<GroupItemParams> get groupsItemsParams {
    final List<GroupItemParams> matchingGroups = _groupsFromCourse
        .where(
          (group) => group.name.toLowerCase().contains(
                searchValue.toLowerCase(),
              ),
        )
        .toList();
    matchingGroups.sort(_setGroupsAlphabeticallyByName);
    return matchingGroups;
  }

  bool get areGroupsInCourse => _groupsFromCourse.isNotEmpty;

  CourseGroupsPreviewState copyWith({
    String? courseName,
    String? searchValue,
    List<GroupItemParams>? groupsFromCourse,
  }) {
    return CourseGroupsPreviewState(
      courseName: courseName ?? this.courseName,
      searchValue: searchValue ?? this.searchValue,
      groupsFromCourse: groupsFromCourse ?? _groupsFromCourse,
    );
  }

  int _setGroupsAlphabeticallyByName(
    GroupItemParams group1,
    GroupItemParams group2,
  ) {
    return group1.name.compareTo(group2.name);
  }
}
