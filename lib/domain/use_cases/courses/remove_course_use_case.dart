import 'package:fiszkomaniak/interfaces/courses_interface.dart';

class RemoveCourseUseCase {
  late final CoursesInterface _coursesInterface;

  RemoveCourseUseCase({required CoursesInterface coursesInterface}) {
    _coursesInterface = coursesInterface;
  }

  Future<void> execute({required String courseId}) async {
    await _coursesInterface.removeCourse(courseId: courseId);
  }
}
