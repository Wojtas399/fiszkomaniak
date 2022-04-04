import 'package:equatable/equatable.dart';

abstract class CoursesStatus extends Equatable {
  const CoursesStatus();

  @override
  List<Object> get props => [];
}

class CoursesStatusInitial extends CoursesStatus {
  const CoursesStatusInitial();
}

class CoursesStatusLoaded extends CoursesStatus {
  const CoursesStatusLoaded();
}

class CoursesStatusLoading extends CoursesStatus {}

class CoursesStatusCourseAdded extends CoursesStatus {}

class CoursesStatusCourseUpdated extends CoursesStatus {}

class CoursesStatusCourseRemoved extends CoursesStatus {}

class CoursesStatusError extends CoursesStatus {
  final String message;

  const CoursesStatusError({required this.message});

  @override
  List<Object> get props => [message];
}
