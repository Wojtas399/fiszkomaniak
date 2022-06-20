import 'package:fiszkomaniak/domain/use_cases/courses/remove_course_use_case.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoursesInterface extends Mock implements CoursesInterface {}

void main() {
  final coursesInterface = MockCoursesInterface();
  final useCase = RemoveCourseUseCase(coursesInterface: coursesInterface);

  test(
    'should call method from courses interface responsible for removing course',
    () async {
      when(
        () => coursesInterface.removeCourse(courseId: 'c1'),
      ).thenAnswer((_) async => '');

      await useCase.execute(courseId: 'c1');

      verify(() => coursesInterface.removeCourse(courseId: 'c1')).called(1);
    },
  );
}
