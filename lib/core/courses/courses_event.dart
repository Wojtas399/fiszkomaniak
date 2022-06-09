part of 'courses_bloc.dart';

abstract class CoursesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CoursesEventInitialize extends CoursesEvent {}

class CoursesEventCoursesChanged extends CoursesEvent {
  final List<Course> addedCourses;
  final List<Course> updatedCourses;
  final List<Course> deletedCourses;

  CoursesEventCoursesChanged({
    required this.addedCourses,
    required this.updatedCourses,
    required this.deletedCourses,
  });

  @override
  List<Object> get props => [
        addedCourses,
        updatedCourses,
        deletedCourses,
      ];
}

class CoursesEventAddNewCourse extends CoursesEvent {
  final String name;

  CoursesEventAddNewCourse({required this.name});

  @override
  List<Object> get props => [name];
}

class CoursesEventUpdateCourseName extends CoursesEvent {
  final String courseId;
  final String newCourseName;

  CoursesEventUpdateCourseName({
    required this.courseId,
    required this.newCourseName,
  });

  @override
  List<Object> get props => [courseId, newCourseName];
}

class CoursesEventRemoveCourse extends CoursesEvent {
  final String courseId;
  final List<String> idsOfGroupsFromCourse;

  CoursesEventRemoveCourse({
    required this.courseId,
    required this.idsOfGroupsFromCourse,
  });

  @override
  List<Object> get props => [
        courseId,
        idsOfGroupsFromCourse,
      ];
}
