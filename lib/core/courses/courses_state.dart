part of 'courses_bloc.dart';

class CoursesState extends Equatable {
  final InitializationStatus initializationStatus;
  late final List<Course> _allCourses;
  final CoursesStatus status;

  CoursesState({
    this.initializationStatus = InitializationStatus.loading,
    List<Course> allCourses = const [],
    this.status = const CoursesStatusInitial(),
  }) {
    _allCourses = allCourses;
  }

  @override
  List<Object> get props => [
        initializationStatus,
        allCourses,
        status,
      ];

  List<Course> get allCourses {
    List<Course> sortedCourses = [..._allCourses];
    sortedCourses.sort(
      (course1, course2) => course1.name.compareTo(course2.name),
    );
    return sortedCourses;
  }

  CoursesState copyWith({
    InitializationStatus? initializationStatus,
    List<Course>? allCourses,
    CoursesStatus? status,
  }) {
    return CoursesState(
      initializationStatus: initializationStatus ?? this.initializationStatus,
      allCourses: allCourses ?? this.allCourses,
      status: status ?? const CoursesStatusLoaded(),
    );
  }

  Course? getCourseById(String? courseId) {
    final List<Course?> courses = [...allCourses];
    return courses.firstWhere(
      (course) => course?.id == courseId,
      orElse: () => null,
    );
  }

  String? getCourseNameById(String? courseId) {
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

  bool isThereCourseWithTheSameName(String courseName) {
    final List<Course?> courses = [...allCourses];
    final Course? matchingCourse = courses.firstWhere(
      (course) => course?.name == courseName,
      orElse: () => null,
    );
    return matchingCourse != null;
  }
}
