part of 'courses_library_bloc.dart';

abstract class CoursesLibraryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CoursesLibraryEventInitialize extends CoursesLibraryEvent {}

class CoursesLibraryEventCoursesItemsParamsUpdated extends CoursesLibraryEvent {
  final List<CourseItemParams> updatedCoursesItemsParams;

  CoursesLibraryEventCoursesItemsParamsUpdated({
    required this.updatedCoursesItemsParams,
  });

  @override
  List<Object> get props => [updatedCoursesItemsParams];
}

class CoursesLibraryEventCoursePressed extends CoursesLibraryEvent {
  final String courseId;

  CoursesLibraryEventCoursePressed({required this.courseId});

  @override
  List<Object> get props => [courseId];
}

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
