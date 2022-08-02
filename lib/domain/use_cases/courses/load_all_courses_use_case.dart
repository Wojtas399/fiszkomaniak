import 'package:fiszkomaniak/interfaces/courses_interface.dart';

class LoadAllCoursesUseCase {
  late final CoursesInterface _coursesInterface;

  LoadAllCoursesUseCase({required CoursesInterface coursesInterface}) {
    _coursesInterface = coursesInterface;
  }

  Future<void> execute() async {
    await _coursesInterface.loadAllCourses();
  }
}
