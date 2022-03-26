import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import '../../models/course_model.dart';

class CoursesState extends Equatable {
  final List<Course> allCourses;
  final HttpStatus httpStatus;

  const CoursesState({
    this.allCourses = const [],
    this.httpStatus = const HttpStatusInitial(),
  });

  CoursesState copyWith({
    List<Course>? allCourses,
    HttpStatus? httpStatus,
  }) {
    return CoursesState(
      allCourses: allCourses ?? this.allCourses,
      httpStatus: httpStatus ?? const HttpStatusInitial(),
    );
  }

  @override
  List<Object> get props => [
        allCourses,
        httpStatus,
      ];
}
