import 'package:fiszkomaniak/models/course_model.dart';

abstract class CoursesEvent {}

class CoursesEventInitialize extends CoursesEvent {}

class CoursesEventCourseAdded extends CoursesEvent {
  final Course course;

  CoursesEventCourseAdded({required this.course});
}

class CoursesEventCourseModified extends CoursesEvent {
  final Course course;

  CoursesEventCourseModified({required this.course});
}

class CoursesEventCourseRemoved extends CoursesEvent {
  final String courseId;

  CoursesEventCourseRemoved({required this.courseId});
}

class CoursesEventAddNewCourse extends CoursesEvent {
  final String name;

  CoursesEventAddNewCourse({required this.name});
}
