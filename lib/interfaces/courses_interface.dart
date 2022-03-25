import 'package:fiszkomaniak/models/course_model.dart';
import '../models/changed_document.dart';

abstract class CoursesInterface {
  Stream<List<ChangedDocument<Course>>> getCoursesSnapshots();

  Future<void> addNewCourse(String name);

  Future<void> updateCourseName({
    required String courseId,
    required String newCourseName,
  });

  Future<void> removeCourse(String courseId);
}
