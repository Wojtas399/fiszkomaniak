import '../../../interfaces/courses_interface.dart';

class DeleteCourseUseCase {
  late final CoursesInterface _coursesInterface;

  DeleteCourseUseCase({required CoursesInterface coursesInterface}) {
    _coursesInterface = coursesInterface;
  }

  Future<void> execute({required String courseId}) async {
    await _coursesInterface.deleteCourse(courseId: courseId);
  }
}
