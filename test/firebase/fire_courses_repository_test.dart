import 'package:fiszkomaniak/firebase/repositories/fire_courses_repository.dart';
import 'package:fiszkomaniak/firebase/services/fire_courses_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFireCoursesService extends Mock implements FireCoursesService {}

void main() {
  final FireCoursesService fireCoursesService = MockFireCoursesService();
  late FireCoursesRepository fireCoursesRepository;

  setUp(() {
    fireCoursesRepository = FireCoursesRepository(
      fireCoursesService: fireCoursesService,
    );
  });

  tearDown(() {
    reset(fireCoursesService);
  });

  test('add new course', () async {
    const String courseName = 'New course name';
    when(() => fireCoursesService.addNewCourse(courseName))
        .thenAnswer((_) async => '');

    await fireCoursesRepository.addNewCourse(courseName);

    verify(() => fireCoursesService.addNewCourse(courseName)).called(1);
  });

  test('update course name', () async {
    const String courseId = 'c1';
    const String newCourseName = 'updated name';
    when(
      () => fireCoursesService.updateCourseName(
        courseId: courseId,
        newName: newCourseName,
      ),
    ).thenAnswer((_) async => '');

    await fireCoursesRepository.updateCourseName(
      courseId: courseId,
      newCourseName: newCourseName,
    );

    verify(
      () => fireCoursesService.updateCourseName(
        courseId: courseId,
        newName: newCourseName,
      ),
    ).called(1);
  });

  test('remove course', () async {
    const String courseId = 'c1';
    when(() => fireCoursesService.removeCourse(courseId))
        .thenAnswer((_) async => '');

    await fireCoursesRepository.removeCourse(courseId);

    verify(() => fireCoursesService.removeCourse(courseId)).called(1);
  });
}
