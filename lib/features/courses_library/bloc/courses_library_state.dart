part of 'courses_library_bloc.dart';

class CoursesLibraryState extends Equatable {
  final BlocStatus status;
  final List<Course> courses;

  const CoursesLibraryState({
    this.status = const BlocStatusInitial(),
    this.courses = const [],
  });

  @override
  List<Object> get props => [status, courses];

  CoursesLibraryState copyWith({
    BlocStatus? status,
    List<Course>? courses,
  }) {
    return CoursesLibraryState(
      status: status ?? const BlocStatusComplete(),
      courses: courses ?? this.courses,
    );
  }
}

enum CoursesLibraryInfoType {
  courseHasBeenRemoved,
}
