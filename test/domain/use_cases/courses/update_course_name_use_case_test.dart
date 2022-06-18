import 'package:fiszkomaniak/domain/use_cases/courses/update_course_name_use_case.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoursesInterface extends Mock implements CoursesInterface {}

void main() {
  final CoursesInterface coursesInterface = MockCoursesInterface();
  late UpdateCourseNameUseCase useCase;

  setUp(() {
    useCase = UpdateCourseNameUseCase(coursesInterface: coursesInterface);
  });

  tearDown(() {
    reset(coursesInterface);
  });

  test(
    'should call method from courses interface responsible for updating course name',
    () async {
      when(
        () => coursesInterface.updateCourseName(
          courseId: 'c1',
          newCourseName: 'new course name',
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute(courseId: 'c1', newCourseName: 'new course name');

      verify(
        () => coursesInterface.updateCourseName(
          courseId: 'c1',
          newCourseName: 'new course name',
        ),
      ).called(1);
    },
  );
}
