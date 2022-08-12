import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/repositories/courses_repository.dart';
import 'package:fiszkomaniak/firebase/fire_document.dart';
import 'package:fiszkomaniak/firebase/models/course_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_courses_service.dart';

class MockFireCoursesService extends Mock implements FireCoursesService {}

void main() {
  final FireCoursesService fireCoursesService = MockFireCoursesService();
  late CoursesRepository repository;

  setUp(() {
    repository = CoursesRepository(fireCoursesService: fireCoursesService);
  });

  tearDown(() {
    reset(fireCoursesService);
  });

  test(
    'initial courses stream should be empty array',
    () async {
      final allCourses = await repository.allCourses$.first;

      expect(allCourses, []);
    },
  );

  test(
    'get course by id, should only return course if it has been already loaded',
    () async {
      final List<FireDocument<CourseDbModel>> coursesFromDb = [
        FireDocument(id: 'c1', data: CourseDbModel(name: 'course 1')),
        FireDocument(id: 'c2', data: CourseDbModel(name: 'course 2')),
      ];
      when(
        () => fireCoursesService.loadAllCourses(),
      ).thenAnswer((_) async => coursesFromDb);

      await repository.loadAllCourses();
      final Stream<Course> course$ = repository.getCourseById('c1');

      expect(await course$.first, const Course(id: 'c1', name: 'course 1'));
      verifyNever(
        () => fireCoursesService.getCourseById(
          courseId: any(named: 'courseId'),
        ),
      );
    },
  );

  test(
    'get course by id, should load course from db if it has not been loaded yet',
    () async {
      final FireDocument<CourseDbModel> courseFromDb = FireDocument(
        id: 'c1',
        data: CourseDbModel(name: 'course 1'),
      );
      when(
        () => fireCoursesService.getCourseById(courseId: 'c1'),
      ).thenAnswer((_) async => courseFromDb);

      final Stream<Course> course$ = repository.getCourseById('c1');

      expect(await course$.first, const Course(id: 'c1', name: 'course 1'));
      verify(
        () => fireCoursesService.getCourseById(courseId: 'c1'),
      ).called(1);
    },
  );

  test(
    'get course by id, returned stream should be empty if course does not exist',
    () async {
      when(
        () => fireCoursesService.getCourseById(courseId: 'c1'),
      ).thenAnswer((_) async => null);

      final Stream<Course> course$ = repository.getCourseById('c1');

      expect(await course$.isEmpty, true);
      verify(
        () => fireCoursesService.getCourseById(courseId: 'c1'),
      ).called(1);
    },
  );

  test(
    'get course name by id, should return course name',
    () async {
      final List<FireDocument<CourseDbModel>> coursesFromDb = [
        FireDocument(id: 'c1', data: CourseDbModel(name: 'course 1')),
        FireDocument(id: 'c2', data: CourseDbModel(name: 'course 2')),
      ];
      when(
        () => fireCoursesService.loadAllCourses(),
      ).thenAnswer((_) async => coursesFromDb);

      await repository.loadAllCourses();
      final Stream<String> courseName = repository.getCourseNameById('c1');

      expect(await courseName.first, 'course 1');
    },
  );

  test(
    'load all courses, should load courses from db and convert them to course model',
    () async {
      final List<FireDocument<CourseDbModel>> coursesFromDb = [
        FireDocument(id: 'c1', data: CourseDbModel(name: 'course 1')),
        FireDocument(id: 'c2', data: CourseDbModel(name: 'course 12')),
        FireDocument(id: 'c3', data: CourseDbModel(name: 'course 123')),
      ];
      when(
        () => fireCoursesService.loadAllCourses(),
      ).thenAnswer((_) async => coursesFromDb);

      await repository.loadAllCourses();

      final allCourses = await repository.allCourses$.first;
      verify(() => fireCoursesService.loadAllCourses()).called(1);
      expect(
        allCourses,
        [
          createCourse(id: 'c1', name: 'course 1'),
          createCourse(id: 'c2', name: 'course 12'),
          createCourse(id: 'c3', name: 'course 123'),
        ],
      );
    },
  );

  test(
    'add new course, should add new course to db and update courses stream',
    () async {
      final FireDocument<CourseDbModel> courseFromDb = FireDocument(
        id: 'c1',
        data: CourseDbModel(name: 'course 1'),
      );
      when(
        () => fireCoursesService.addNewCourse('course 1'),
      ).thenAnswer((_) async => courseFromDb);

      await repository.addNewCourse(name: 'course 1');

      final List<Course> allCourses = await repository.allCourses$.first;
      verify(() => fireCoursesService.addNewCourse('course 1')).called(1);
      expect(
        allCourses,
        [const Course(id: 'c1', name: 'course 1')],
      );
    },
  );

  test(
    'update course name, should save new course name to db and update courses stream',
    () async {
      final FireDocument<CourseDbModel> courseFromDb = FireDocument(
        id: 'c1',
        data: CourseDbModel(name: 'course 1'),
      );
      final FireDocument<CourseDbModel> updatedCourseFromDb = FireDocument(
        id: 'c1',
        data: CourseDbModel(name: 'course name 1'),
      );
      when(
        () => fireCoursesService.loadAllCourses(),
      ).thenAnswer((_) async => [courseFromDb]);
      when(
        () => fireCoursesService.updateCourseName(
          courseId: 'c1',
          newName: 'course name 1',
        ),
      ).thenAnswer((_) async => updatedCourseFromDb);

      await repository.loadAllCourses();
      await repository.updateCourseName(
        courseId: 'c1',
        newCourseName: 'course name 1',
      );

      final List<Course> allCourses = await repository.allCourses$.first;
      verify(
        () => fireCoursesService.updateCourseName(
          courseId: 'c1',
          newName: 'course name 1',
        ),
      ).called(1);
      expect(
        allCourses,
        [const Course(id: 'c1', name: 'course name 1')],
      );
    },
  );

  test(
    'delete course, should remove course from db and update courses stream',
    () async {
      final FireDocument<CourseDbModel> courseFromDb = FireDocument(
        id: 'c1',
        data: CourseDbModel(name: 'course 1'),
      );
      when(
        () => fireCoursesService.loadAllCourses(),
      ).thenAnswer((_) async => [courseFromDb]);
      when(
        () => fireCoursesService.removeCourse('c1'),
      ).thenAnswer((_) async => 'c1');

      await repository.deleteCourse(courseId: 'c1');

      final List<Course> allCourses = await repository.allCourses$.first;
      verify(() => fireCoursesService.removeCourse('c1')).called(1);
      expect(allCourses, []);
    },
  );

  test(
    'is course name already taken, should return true if course with the same name has been already loaded',
    () async {
      final List<FireDocument<CourseDbModel>> coursesFromDb = [
        FireDocument(id: 'c1', data: CourseDbModel(name: 'course 1')),
        FireDocument(id: 'c2', data: CourseDbModel(name: 'course 2')),
      ];
      when(
        () => fireCoursesService.loadAllCourses(),
      ).thenAnswer((_) async => coursesFromDb);

      await repository.loadAllCourses();
      final bool isCourseNameAlreadyTaken =
          await repository.isCourseNameAlreadyTaken('course 1');

      expect(isCourseNameAlreadyTaken, true);
      verifyNever(
        () => fireCoursesService.isThereCourseWithTheName(
          courseName: any(named: 'courseName'),
        ),
      );
    },
  );

  test(
    'is course name already taken, should return db response if course with the same name has not been loaded yet',
    () async {
      when(
        () => fireCoursesService.isThereCourseWithTheName(
          courseName: 'course 1',
        ),
      ).thenAnswer((_) async => true);

      final bool isCourseNameAlreadyTaken =
          await repository.isCourseNameAlreadyTaken('course 1');

      expect(isCourseNameAlreadyTaken, true);
      verify(
        () => fireCoursesService.isThereCourseWithTheName(
          courseName: 'course 1',
        ),
      ).called(1);
    },
  );

  test(
    'is course name already taken, should return db response if course with the same name has not been already loaded',
    () async {
      when(
        () => fireCoursesService.isThereCourseWithTheName(
          courseName: 'course 1',
        ),
      ).thenAnswer((_) async => false);

      final bool isCourseNameAlreadyTaken =
          await repository.isCourseNameAlreadyTaken('course 1');

      expect(isCourseNameAlreadyTaken, false);
      verify(
        () => fireCoursesService.isThereCourseWithTheName(
          courseName: 'course 1',
        ),
      ).called(1);
    },
  );
}
