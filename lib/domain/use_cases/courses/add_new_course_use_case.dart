import '../../../interfaces/courses_interface.dart';

class AddNewCourseUseCase {
  late final CoursesInterface _coursesInterface;

  AddNewCourseUseCase({required CoursesInterface coursesInterface}) {
    _coursesInterface = coursesInterface;
  }

  Future<void> execute({required String courseName}) async {
    await _coursesInterface.addNewCourse(name: courseName);
  }
}
