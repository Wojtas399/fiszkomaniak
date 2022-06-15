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

class CourseGroupsPreviewEventCourseUpdated extends CourseGroupsPreviewEvent {
  final Course updatedCourse;

  CourseGroupsPreviewEventCourseUpdated({required this.updatedCourse});

  @override
  List<Object> get props => [updatedCourse];
}

class CourseGroupsPreviewEventGroupsStateChanged
    extends CourseGroupsPreviewEvent {}

class CourseGroupsPreviewEventSearchValueChanged
    extends CourseGroupsPreviewEvent {
  final String searchValue;

  CourseGroupsPreviewEventSearchValueChanged({required this.searchValue});

  @override
  List<Object> get props => [searchValue];
}
