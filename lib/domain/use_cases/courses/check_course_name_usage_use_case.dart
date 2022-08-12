import '../../../interfaces/courses_interface.dart';

class CheckCourseNameUsageUseCase {
  late final CoursesInterface _coursesInterface;

  CheckCourseNameUsageUseCase({
    required CoursesInterface coursesInterface,
  }) {
    _coursesInterface = coursesInterface;
  }

  Future<bool> execute({required String courseName}) async {
    return await _coursesInterface.isCourseNameAlreadyTaken(courseName);
  }
}
