part of 'courses_library_bloc.dart';

class CoursesLibraryState extends Equatable {
  final BlocStatus status;
  final List<CourseItemParams> coursesItemsParams;

  const CoursesLibraryState({
    this.status = const BlocStatusInitial(),
    this.coursesItemsParams = const [],
  });

  @override
  List<Object> get props => [status, coursesItemsParams];

  bool get areCourses => coursesItemsParams.isNotEmpty;

  CoursesLibraryState copyWith({
    BlocStatus? status,
    List<CourseItemParams>? coursesItemsParams,
  }) {
    return CoursesLibraryState(
      status: status ?? const BlocStatusComplete(),
      coursesItemsParams: coursesItemsParams ?? this.coursesItemsParams,
    );
  }
}

enum CoursesLibraryInfoType {
  courseHasBeenRemoved,
}
