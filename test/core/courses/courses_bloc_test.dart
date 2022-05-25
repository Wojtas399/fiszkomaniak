import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/initialization_status.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:fiszkomaniak/models/changed_document.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoursesInterface extends Mock implements CoursesInterface {}

void main() {
  final CoursesInterface coursesInterface = MockCoursesInterface();
  late CoursesBloc coursesBloc;

  setUp(() {
    coursesBloc = CoursesBloc(coursesInterface: coursesInterface);
  });

  tearDown(() {
    reset(coursesInterface);
  });

  blocTest(
    'initialize',
    build: () => coursesBloc,
    setUp: () {
      when(() => coursesInterface.getCoursesSnapshots()).thenAnswer(
        (_) => Stream.value([
          ChangedDocument(
            changeType: DbDocChangeType.added,
            doc: createCourse(id: 'c1'),
          ),
          ChangedDocument(
            changeType: DbDocChangeType.added,
            doc: createCourse(id: 'c2'),
          ),
          ChangedDocument(
            changeType: DbDocChangeType.added,
            doc: createCourse(id: 'c3', name: 'course 3'),
          ),
          ChangedDocument(
            changeType: DbDocChangeType.updated,
            doc: createCourse(id: 'c3', name: 'course 123'),
          ),
          ChangedDocument(
            changeType: DbDocChangeType.removed,
            doc: createCourse(id: 'c3', name: 'course 123'),
          ),
        ]),
      );
    },
    act: (_) => coursesBloc.add(CoursesEventInitialize()),
    expect: () => [
      CoursesState(
        initializationStatus: InitializationStatus.ready,
        allCourses: [
          createCourse(id: 'c1'),
          createCourse(id: 'c2'),
        ],
        status: const CoursesStatusLoaded(),
      ),
    ],
  );

  blocTest(
    'add new course, success',
    build: () => coursesBloc,
    setUp: () {
      when(() => coursesInterface.addNewCourse('new course name'))
          .thenAnswer((_) async => '');
    },
    act: (_) => coursesBloc.add(
      CoursesEventAddNewCourse(name: 'new course name'),
    ),
    expect: () => [
      CoursesState(status: CoursesStatusLoading()),
      CoursesState(status: CoursesStatusCourseAdded()),
    ],
    verify: (_) {
      verify(() => coursesInterface.addNewCourse('new course name')).called(1);
    },
  );

  blocTest(
    'add new course, failure',
    build: () => coursesBloc,
    setUp: () {
      when(() => coursesInterface.addNewCourse('new course name'))
          .thenThrow('Error...');
    },
    act: (_) => coursesBloc.add(
      CoursesEventAddNewCourse(name: 'new course name'),
    ),
    expect: () => [
      CoursesState(status: CoursesStatusLoading()),
      CoursesState(status: const CoursesStatusError(message: 'Error...')),
    ],
    verify: (_) {
      verify(() => coursesInterface.addNewCourse('new course name')).called(1);
    },
  );

  blocTest(
    'update course name, success',
    build: () => coursesBloc,
    setUp: () {
      when(
        () => coursesInterface.updateCourseName(
          courseId: 'c1',
          newCourseName: 'course123',
        ),
      ).thenAnswer((_) async => '');
    },
    act: (_) => coursesBloc.add(
      CoursesEventUpdateCourseName(courseId: 'c1', newCourseName: 'course123'),
    ),
    expect: () => [
      CoursesState(status: CoursesStatusLoading()),
      CoursesState(status: CoursesStatusCourseUpdated()),
    ],
    verify: (_) {
      verify(
        () => coursesInterface.updateCourseName(
          courseId: 'c1',
          newCourseName: 'course123',
        ),
      ).called(1);
    },
  );

  blocTest(
    'update course name, failure',
    build: () => coursesBloc,
    setUp: () {
      when(
        () => coursesInterface.updateCourseName(
          courseId: 'c1',
          newCourseName: 'course123',
        ),
      ).thenThrow('Error...');
    },
    act: (_) => coursesBloc.add(
      CoursesEventUpdateCourseName(courseId: 'c1', newCourseName: 'course123'),
    ),
    expect: () => [
      CoursesState(status: CoursesStatusLoading()),
      CoursesState(status: const CoursesStatusError(message: 'Error...')),
    ],
    verify: (_) {
      verify(
        () => coursesInterface.updateCourseName(
          courseId: 'c1',
          newCourseName: 'course123',
        ),
      ).called(1);
    },
  );

  blocTest(
    'remove course, success',
    build: () => coursesBloc,
    setUp: () {
      when(() => coursesInterface.removeCourse('c1'))
          .thenAnswer((_) async => '');
    },
    act: (_) => coursesBloc.add(
      CoursesEventRemoveCourse(
        courseId: 'c1',
        idsOfGroupsFromCourse: const ['g1', 'g2'],
      ),
    ),
    expect: () => [
      CoursesState(status: CoursesStatusLoading()),
      CoursesState(status: CoursesStatusCourseRemoved()),
    ],
    verify: (_) {
      verify(() => coursesInterface.removeCourse('c1')).called(1);
    },
  );

  blocTest(
    'remove course, failure',
    build: () => coursesBloc,
    setUp: () {
      when(() => coursesInterface.removeCourse('c1')).thenThrow('Error...');
    },
    act: (_) => coursesBloc.add(
      CoursesEventRemoveCourse(
        courseId: 'c1',
        idsOfGroupsFromCourse: const ['g1', 'g2'],
      ),
    ),
    expect: () => [
      CoursesState(status: CoursesStatusLoading()),
      CoursesState(status: const CoursesStatusError(message: 'Error...')),
    ],
    verify: (_) {
      verify(() => coursesInterface.removeCourse('c1')).called(1);
    },
  );
}
