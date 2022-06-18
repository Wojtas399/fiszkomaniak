part of 'course_creator_bloc.dart';

abstract class CourseCreatorStatus extends Equatable {
  const CourseCreatorStatus();

  @override
  List<Object> get props => [];
}

class CourseCreatorStatusInitial extends CourseCreatorStatus {
  const CourseCreatorStatusInitial();
}

class CourseCreatorStatusLoading extends CourseCreatorStatus {}

class CourseCreatorStatusLoaded extends CourseCreatorStatus {}

class CourseCreatorStatusCourseNameIsAlreadyTaken extends CourseCreatorStatus {}

class CourseCreatorStatusCourseAdded extends CourseCreatorStatus {}

class CourseCreatorStatusCourseUpdated extends CourseCreatorStatus {}

class CourseCreatorStatusError extends CourseCreatorStatus {
  final String message;

  const CourseCreatorStatusError({required this.message});

  @override
  List<Object> get props => [message];
}
