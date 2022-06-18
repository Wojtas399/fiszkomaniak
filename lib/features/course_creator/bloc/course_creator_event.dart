part of 'course_creator_bloc.dart';

abstract class CourseCreatorEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CourseCreatorEventInitialize extends CourseCreatorEvent {
  final CourseCreatorMode mode;

  CourseCreatorEventInitialize({required this.mode});

  @override
  List<Object> get props => [mode];
}

class CourseCreatorEventCourseNameChanged extends CourseCreatorEvent {
  final String courseName;

  CourseCreatorEventCourseNameChanged({required this.courseName});

  @override
  List<Object> get props => [courseName];
}

class CourseCreatorEventSaveChanges extends CourseCreatorEvent {}
