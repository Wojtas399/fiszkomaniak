import 'package:fiszkomaniak/features/course_creator/course_creator_arguments.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';

abstract class CourseCreatorEvent {}

class CourseCreatorEventInitialize extends CourseCreatorEvent {
  final CourseCreatorMode mode;

  CourseCreatorEventInitialize({required this.mode});
}

class CourseCreatorEventCourseNameChanged extends CourseCreatorEvent {
  final String courseName;

  CourseCreatorEventCourseNameChanged({required this.courseName});
}

class CourseCreatorEventHttpStatusChanged extends CourseCreatorEvent {
  final HttpStatus httpStatus;

  CourseCreatorEventHttpStatusChanged({required this.httpStatus});
}

class CourseCreatorEventSaveChanges extends CourseCreatorEvent {}
