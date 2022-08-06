part of 'courses_library_bloc.dart';

abstract class CoursesLibraryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CoursesLibraryEventInitialize extends CoursesLibraryEvent {}

class CoursesLibraryEventAllCoursesUpdated extends CoursesLibraryEvent {
  final List<Course> allCourses;

  CoursesLibraryEventAllCoursesUpdated({
    required this.allCourses,
  });

  @override
  List<Object> get props => [allCourses];
}

class CoursesLibraryEventDeleteCourse extends CoursesLibraryEvent {
  final String courseId;

  CoursesLibraryEventDeleteCourse({required this.courseId});

  @override
  List<Object> get props => [courseId];
}
