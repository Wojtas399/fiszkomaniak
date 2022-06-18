import 'package:fiszkomaniak/domain/use_cases/courses/add_new_course_use_case.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoursesInterface extends Mock implements CoursesInterface {}

void main() {
  final CoursesInterface coursesInterface = MockCoursesInterface();
  late AddNewCourseUseCase useCase;

  setUp(() {
    useCase = AddNewCourseUseCase(coursesInterface: coursesInterface);
  });

  tearDown(() {
    reset(coursesInterface);
  });

  test(
    'should call method from courses interface responsible from adding new course',
    () async {
      when(
        () => coursesInterface.addNewCourse(name: 'course name'),
      ).thenAnswer((_) async => '');

      await useCase.execute(courseName: 'course name');

      verify(
        () => coursesInterface.addNewCourse(name: 'course name'),
      ).called(1);
    },
  );
}
