import '../domain/entities/course.dart';

class CoursesUtils {
  List<Course> setCourseInAlphabeticalOrderByName(List<Course> courses) {
    final List<Course> sortedCourses = [...courses];
    sortedCourses.sort(_compareCoursesNames);
    return sortedCourses;
  }

  int _compareCoursesNames(Course course1, Course course2) {
    return course1.name.toLowerCase().compareTo(course2.name.toLowerCase());
  }
}
