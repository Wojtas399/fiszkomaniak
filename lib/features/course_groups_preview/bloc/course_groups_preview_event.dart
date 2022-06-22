part of 'course_groups_preview_bloc.dart';

abstract class CourseGroupsPreviewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CourseGroupsPreviewEventInitialize extends CourseGroupsPreviewEvent {
  final String courseId;

  CourseGroupsPreviewEventInitialize({required this.courseId});

  @override
  List<Object> get props => [courseId];
}

class CourseGroupsPreviewEventCourseNameUpdated
    extends CourseGroupsPreviewEvent {
  final String updatedCourseName;

  CourseGroupsPreviewEventCourseNameUpdated({required this.updatedCourseName});

  @override
  List<Object> get props => [updatedCourseName];
}

class CourseGroupsPreviewEventGroupsUpdated extends CourseGroupsPreviewEvent {
  final List<GroupItemParams> updatedGroups;

  CourseGroupsPreviewEventGroupsUpdated({required this.updatedGroups});

  @override
  List<Object> get props => [updatedGroups];
}

class CourseGroupsPreviewEventSearchValueChanged
    extends CourseGroupsPreviewEvent {
  final String searchValue;

  CourseGroupsPreviewEventSearchValueChanged({required this.searchValue});

  @override
  List<Object> get props => [searchValue];
}
