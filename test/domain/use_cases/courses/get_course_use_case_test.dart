import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoursesInterface extends Mock implements CoursesInterface {}

void main() {
  final coursesInterface = MockCoursesInterface();
  final useCase = GetCourseUseCase(coursesInterface: coursesInterface);

  test(
    'should return stream which contains appropriate course',
    () async {
      final Course expectedCourse = createCourse(id: 'c1', name: 'course 1');
      when(
        () => coursesInterface.getCourseById('c1'),
      ).thenAnswer((_) => Stream.value(expectedCourse));

      final Stream<Course> course$ = useCase.execute(courseId: 'c1');

      expect(await course$.first, expectedCourse);
    },
  );
}
