import 'package:fiszkomaniak/features/course_creator/course_creator_arguments.dart';

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
