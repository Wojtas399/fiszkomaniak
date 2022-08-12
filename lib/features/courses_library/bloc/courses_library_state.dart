part of 'courses_library_bloc.dart';

class CoursesLibraryState extends Equatable {
  final BlocStatus status;
  final List<Course> allCourses;

  const CoursesLibraryState({
    required this.status,
    required this.allCourses,
  });

  @override
  List<Object> get props => [
        status,
        allCourses,
      ];

  bool get areCourses => allCourses.isNotEmpty;

  CoursesLibraryState copyWith({
    BlocStatus? status,
    List<Course>? allCourses,
  }) {
    return CoursesLibraryState(
      status: status ?? const BlocStatusInProgress(),
      allCourses: allCourses ?? this.allCourses,
    );
  }

  CoursesLibraryState copyWithInfo(CoursesLibraryInfo info) {
    return copyWith(
      status: BlocStatusComplete<CoursesLibraryInfo>(info: info),
    );
  }
}

enum CoursesLibraryInfo {
  courseHasBeenRemoved,
}
