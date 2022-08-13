part of 'courses_library_bloc.dart';

abstract class CoursesLibraryEvent {}

class CoursesLibraryEventInitialize extends CoursesLibraryEvent {}

class CoursesLibraryEventAllCoursesUpdated extends CoursesLibraryEvent {
  final List<Course> allCourses;

  CoursesLibraryEventAllCoursesUpdated({
    required this.allCourses,
  });
}

class CoursesLibraryEventDeleteCourse extends CoursesLibraryEvent {
  final String courseId;

  CoursesLibraryEventDeleteCourse({required this.courseId});
}
