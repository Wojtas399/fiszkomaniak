import 'package:fiszkomaniak/domain/use_cases/courses/load_all_courses_use_case.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoursesInterface extends Mock implements CoursesInterface {}

void main() {
  final coursesInterface = MockCoursesInterface();
  final useCase = LoadAllCoursesUseCase(coursesInterface: coursesInterface);

  test(
    'should call method from courses interface responsible for loading all courses from db',
    () async {
      when(() => coursesInterface.loadAllCourses()).thenAnswer((_) async => '');

      await useCase.execute();

      verify(() => coursesInterface.loadAllCourses()).called(1);
    },
  );
}
