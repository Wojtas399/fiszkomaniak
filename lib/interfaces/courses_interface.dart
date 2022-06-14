import 'package:fiszkomaniak/models/course_model.dart';

abstract class CoursesInterface {
  Stream<List<Course>> get allCourses$;

  Future<void> loadCoursesByIds(List<String> coursesIds);

  Future<void> loadAllCourses();

  Future<void> addNewCourse(String name);

  Future<void> updateCourseName({
    required String courseId,
    required String newCourseName,
  });

  Future<void> removeCourse(String courseId);

  Stream<Course> getCourseById(String courseId);

  Stream<String> getCourseNameById(String courseId);

  Future<bool> isThereCourseWithTheSameName(String courseName);
}
