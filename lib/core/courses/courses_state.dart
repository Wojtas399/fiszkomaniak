import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import '../../models/course_model.dart';

class CoursesState extends Equatable {
  late final List<Course> _allCourses;
  final HttpStatus httpStatus;

  List<Course> get allCourses {
    List<Course> sortedCourses = [..._allCourses];
    sortedCourses.sort(
      (course1, course2) => course1.name.compareTo(course2.name),
    );
    return sortedCourses;
  }

  CoursesState({
    List<Course> allCourses = const [],
    this.httpStatus = const HttpStatusInitial(),
  }) {
    _allCourses = allCourses;
  }

  CoursesState copyWith({
    List<Course>? allCourses,
    HttpStatus? httpStatus,
  }) {
    return CoursesState(
      allCourses: allCourses ?? this.allCourses,
      httpStatus: httpStatus ?? const HttpStatusInitial(),
    );
  }

  String? getCourseNameById(String courseId) {
    final List<Course?> courses = [...allCourses];
    final Course? course = courses.firstWhere(
      (course) => course?.id == courseId,
      orElse: () => null,
    );
    if (course != null) {
      return course.name;
    }
    return null;
  }

  @override
  List<Object> get props => [
        allCourses,
        httpStatus,
      ];
}
