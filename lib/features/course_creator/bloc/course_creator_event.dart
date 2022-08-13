part of 'course_creator_bloc.dart';

abstract class CourseCreatorEvent {}

class CourseCreatorEventInitialize extends CourseCreatorEvent {
  final CourseCreatorMode mode;

  CourseCreatorEventInitialize({required this.mode});
}

class CourseCreatorEventCourseNameChanged extends CourseCreatorEvent {
  final String courseName;

  CourseCreatorEventCourseNameChanged({required this.courseName});
}

class CourseCreatorEventSaveChanges extends CourseCreatorEvent {}
