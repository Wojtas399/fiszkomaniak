import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_all_courses_use_case.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoursesInterface extends Mock implements CoursesInterface {}

void main() {
  final coursesInterface = MockCoursesInterface();
  final useCase = GetAllCoursesUseCase(coursesInterface: coursesInterface);

  test(
    'should return all courses stream from courses interface',
    () async {
      final List<Course> expectedCourses = [
        createCourse(id: 'c1'),
        createCourse(id: 'c2'),
      ];
      when(
        () => coursesInterface.allCourses$,
      ).thenAnswer((_) => Stream.value(expectedCourses));

      final Stream<List<Course>> allCourses$ = useCase.execute();

      expect(await allCourses$.first, expectedCourses);
    },
  );
}
