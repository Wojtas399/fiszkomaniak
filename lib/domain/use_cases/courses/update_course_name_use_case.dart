import 'package:fiszkomaniak/interfaces/courses_interface.dart';

class UpdateCourseNameUseCase {
  late final CoursesInterface _coursesInterface;

  UpdateCourseNameUseCase({required CoursesInterface coursesInterface}) {
    _coursesInterface = coursesInterface;
  }

  Future<void> execute({
    required String courseId,
    required String newCourseName,
  }) async {
    await _coursesInterface.updateCourseName(
      courseId: courseId,
      newCourseName: newCourseName,
    );
  }
}
