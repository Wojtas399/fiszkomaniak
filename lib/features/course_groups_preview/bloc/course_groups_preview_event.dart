part of 'course_groups_preview_bloc.dart';

abstract class CourseGroupsPreviewEvent {}

class CourseGroupsPreviewEventInitialize extends CourseGroupsPreviewEvent {
  final String courseId;

  CourseGroupsPreviewEventInitialize({required this.courseId});
}

class CourseGroupsPreviewEventListenedParamsUpdated
    extends CourseGroupsPreviewEvent {
  final CourseGroupsPreviewStateListenedParams params;

  CourseGroupsPreviewEventListenedParamsUpdated({required this.params});
}

class CourseGroupsPreviewEventSearchValueChanged
    extends CourseGroupsPreviewEvent {
  final String searchValue;

  CourseGroupsPreviewEventSearchValueChanged({required this.searchValue});
}
