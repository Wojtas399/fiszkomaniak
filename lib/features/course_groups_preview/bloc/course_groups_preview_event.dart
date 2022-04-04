abstract class CourseGroupsPreviewEvent {}

class CourseGroupsPreviewEventInitialize extends CourseGroupsPreviewEvent {
  final String courseId;

  CourseGroupsPreviewEventInitialize({required this.courseId});
}

class CourseGroupsPreviewEventGroupsStateChanged
    extends CourseGroupsPreviewEvent {}

class CourseGroupsPreviewEventSearchValueChanged
    extends CourseGroupsPreviewEvent {
  final String searchValue;

  CourseGroupsPreviewEventSearchValueChanged({required this.searchValue});
}
