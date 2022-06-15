part of 'course_groups_preview_bloc.dart';

class CourseGroupsPreviewState extends Equatable {
  final Course? course;
  final List<Group> groupsFromCourse;
  final String searchValue;

  List<Group> get matchingGroups {
    return groupsFromCourse
        .where(
          (group) => group.name.toLowerCase().contains(
                searchValue.toLowerCase(),
              ),
        )
        .toList();
  }

  String get courseName => course?.name ?? '';

  const CourseGroupsPreviewState({
    this.course,
    this.groupsFromCourse = const [],
    this.searchValue = '',
  });

  CourseGroupsPreviewState copyWith({
    Course? course,
    List<Group>? groupsFromCourse,
    String? searchValue,
  }) {
    return CourseGroupsPreviewState(
      course: course ?? this.course,
      groupsFromCourse: groupsFromCourse ?? this.groupsFromCourse,
      searchValue: searchValue ?? this.searchValue,
    );
  }

  @override
  List<Object> get props => [
        course ?? createCourse(),
        groupsFromCourse,
        searchValue,
      ];
}
