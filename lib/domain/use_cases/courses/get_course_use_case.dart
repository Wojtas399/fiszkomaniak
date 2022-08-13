import '../../../interfaces/courses_interface.dart';
import '../../entities/course.dart';

class GetCourseUseCase {
  late final CoursesInterface _coursesInterface;

  GetCourseUseCase({required CoursesInterface coursesInterface}) {
    _coursesInterface = coursesInterface;
  }

  Stream<Course> execute({required String courseId}) {
    return _coursesInterface.getCourseById(courseId);
  }
}
