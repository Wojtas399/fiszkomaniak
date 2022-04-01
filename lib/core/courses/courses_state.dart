import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/core/courses/courses_status.dart';
import '../../models/course_model.dart';

class CoursesState extends Equatable {
  late final List<Course> _allCourses;
  final CoursesStatus status;

  List<Course> get allCourses {
    List<Course> sortedCourses = [..._allCourses];
    sortedCourses.sort(
      (course1, course2) => course1.name.compareTo(course2.name),
    );
    return sortedCourses;
  }

  CoursesState({
    List<Course> allCourses = const [],
    this.status = const CoursesStatusInitial(),
  }) {
    _allCourses = allCourses;
  }

  CoursesState copyWith({
    List<Course>? allCourses,
    CoursesStatus? status,
  }) {
    return CoursesState(
      allCourses: allCourses ?? this.allCourses,
      status: status ?? const CoursesStatusLoaded(),
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
        status,
      ];
}
