import 'package:fiszkomaniak/domain/use_cases/courses/check_course_name_usage_use_case.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoursesInterface extends Mock implements CoursesInterface {}

void main() {
  final CoursesInterface coursesInterface = MockCoursesInterface();
  late CheckCourseNameUsageUseCase useCase;

  setUp(() {
    useCase = CheckCourseNameUsageUseCase(coursesInterface: coursesInterface);
  });

  tearDown(() {
    reset(coursesInterface);
  });

  test(
    'should return result of method from courses interface responsible for checking if course name is already taken',
    () async {
      when(
        () => coursesInterface.isCourseNameAlreadyTaken('course name'),
      ).thenAnswer((_) async => true);

      final bool isCourseNameAlreadyTaken =
          await useCase.execute(courseName: 'course name');

      expect(isCourseNameAlreadyTaken, true);
      verify(
        () => coursesInterface.isCourseNameAlreadyTaken('course name'),
      ).called(1);
    },
  );
}
