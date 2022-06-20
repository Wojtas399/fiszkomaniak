import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';

class GetAllCoursesUseCase {
  late final CoursesInterface _coursesInterface;

  GetAllCoursesUseCase({required CoursesInterface coursesInterface}) {
    _coursesInterface = coursesInterface;
  }

  Stream<List<Course>> execute() {
    return _coursesInterface.allCourses$;
  }
}
