import '../../../models/course_model.dart';

abstract class CoursesLibraryEvent {}

class CoursesLibraryEventInitialize extends CoursesLibraryEvent {}

class CoursesLibraryEventUpdateCourses extends CoursesLibraryEvent {}

class CoursesLibraryEventEditCourse extends CoursesLibraryEvent {
  final Course course;

  CoursesLibraryEventEditCourse({required this.course});
}

class CoursesLibraryEventRemoveCourse extends CoursesLibraryEvent {
  final String courseId;

  CoursesLibraryEventRemoveCourse({required this.courseId});
}
