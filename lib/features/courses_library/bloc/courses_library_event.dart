part of 'courses_library_bloc.dart';

abstract class CoursesLibraryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CoursesLibraryEventInitialize extends CoursesLibraryEvent {}

class CoursesLibraryEventEditCourse extends CoursesLibraryEvent {
  final Course course;

  CoursesLibraryEventEditCourse({required this.course});

  @override
  List<Object> get props => [course];
}

class CoursesLibraryEventRemoveCourse extends CoursesLibraryEvent {
  final String courseId;

  CoursesLibraryEventRemoveCourse({required this.courseId});

  @override
  List<Object> get props => [courseId];
}

class CoursesLibraryEventCoursesUpdated extends CoursesLibraryEvent {
  final List<Course> updatedCourses;

  CoursesLibraryEventCoursesUpdated({required this.updatedCourses});

  @override
  List<Object> get props => [updatedCourses];
}
