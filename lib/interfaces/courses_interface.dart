import 'package:fiszkomaniak/domain/entities/course.dart';

abstract class CoursesInterface {
  Stream<List<Course>> get allCourses$;

  Future<void> loadAllCourses();

  Future<void> addNewCourse({required String name});

  Future<void> updateCourseName({
    required String courseId,
    required String newCourseName,
  });

  Future<void> removeCourse({required String courseId});

  Stream<Course> getCourseById(String courseId);

  Stream<String> getCourseNameById(String courseId);

  Future<bool> isCourseNameAlreadyTaken(String courseName);
}
