import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/course_model.dart';

abstract class CoursesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CoursesEventInitialize extends CoursesEvent {}

class CoursesEventCourseAdded extends CoursesEvent {
  final Course course;

  CoursesEventCourseAdded({required this.course});

  @override
  List<Object> get props => [course];
}

class CoursesEventCourseModified extends CoursesEvent {
  final Course course;

  CoursesEventCourseModified({required this.course});

  @override
  List<Object> get props => [course];
}

class CoursesEventCourseRemoved extends CoursesEvent {
  final String courseId;

  CoursesEventCourseRemoved({required this.courseId});

  @override
  List<Object> get props => [courseId];
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

  CoursesEventRemoveCourse({required this.courseId});

  @override
  List<Object> get props => [courseId];
}
