import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_event.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:fiszkomaniak/models/changed_document.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
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

  test('initial state', () {
    final CoursesState state = coursesBloc.state;
    expect(state.allCourses, []);
    expect(state.httpStatus, const HttpStatusInitial());
  });

  blocTest(
    'initialize',
    build: () => coursesBloc,
    setUp: () {
      when(() => coursesInterface.getCoursesSnapshots()).thenAnswer(
        (_) => Stream.value([
          const ChangedDocument(
            changeType: TypeOfDocumentChange.added,
            doc: Course(id: 'c1', name: 'course 1'),
          ),
          const ChangedDocument(
            changeType: TypeOfDocumentChange.added,
            doc: Course(id: 'c2', name: 'course 2'),
          ),
          const ChangedDocument(
            changeType: TypeOfDocumentChange.added,
            doc: Course(id: 'c3', name: 'course 3'),
          ),
          const ChangedDocument(
            changeType: TypeOfDocumentChange.modified,
            doc: Course(id: 'c3', name: 'course 123'),
          ),
          const ChangedDocument(
            changeType: TypeOfDocumentChange.removed,
            doc: Course(id: 'c3', name: 'course 123'),
          ),
        ]),
      );
    },
    act: (CoursesBloc bloc) => bloc.add(CoursesEventInitialize()),
    expect: () => [
      const CoursesState(allCourses: [
        Course(id: 'c1', name: 'course 1'),
      ]),
      const CoursesState(allCourses: [
        Course(id: 'c1', name: 'course 1'),
        Course(id: 'c2', name: 'course 2'),
      ]),
      const CoursesState(allCourses: [
        Course(id: 'c1', name: 'course 1'),
        Course(id: 'c2', name: 'course 2'),
        Course(id: 'c3', name: 'course 3'),
      ]),
      const CoursesState(allCourses: [
        Course(id: 'c1', name: 'course 1'),
        Course(id: 'c2', name: 'course 2'),
        Course(id: 'c3', name: 'course 123'),
      ]),
      const CoursesState(allCourses: [
        Course(id: 'c1', name: 'course 1'),
        Course(id: 'c2', name: 'course 2'),
      ]),
    ],
  );

  blocTest(
    'add new course, success',
    build: () => coursesBloc,
    setUp: () {
      when(() => coursesInterface.addNewCourse('new course name'))
          .thenAnswer((_) async => '');
    },
    act: (CoursesBloc bloc) => bloc.add(
      CoursesEventAddNewCourse(name: 'new course name'),
    ),
    expect: () => [
      CoursesState(httpStatus: HttpStatusSubmitting()),
      const CoursesState(
        httpStatus: HttpStatusSuccess(message: 'Pomyślnie dodano nowy kurs.'),
      ),
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
    act: (CoursesBloc bloc) => bloc.add(
      CoursesEventAddNewCourse(name: 'new course name'),
    ),
    expect: () => [
      CoursesState(httpStatus: HttpStatusSubmitting()),
      const CoursesState(
        httpStatus: HttpStatusFailure(message: 'Error...'),
      ),
    ],
    verify: (_) {
      verify(() => coursesInterface.addNewCourse('new course name')).called(1);
    },
  );

  blocTest(
    'update course name, success',
    build: () => coursesBloc,
    setUp: () {
      when(() => coursesInterface.updateCourseName(
            courseId: 'c1',
            newCourseName: 'course123',
          )).thenAnswer((_) async => '');
    },
    act: (CoursesBloc bloc) => bloc.add(
      CoursesEventUpdateCourseName(courseId: 'c1', newCourseName: 'course123'),
    ),
    expect: () => [
      CoursesState(httpStatus: HttpStatusSubmitting()),
      const CoursesState(
        httpStatus: HttpStatusSuccess(
          message: 'Pomyślnie zmieniono nazwę kursu.',
        ),
      ),
    ],
    verify: (_) {
      verify(() => coursesInterface.updateCourseName(
            courseId: 'c1',
            newCourseName: 'course123',
          )).called(1);
    },
  );

  blocTest(
    'update course name, failure',
    build: () => coursesBloc,
    setUp: () {
      when(() => coursesInterface.updateCourseName(
            courseId: 'c1',
            newCourseName: 'course123',
          )).thenThrow('Error...');
    },
    act: (CoursesBloc bloc) => bloc.add(
      CoursesEventUpdateCourseName(courseId: 'c1', newCourseName: 'course123'),
    ),
    expect: () => [
      CoursesState(httpStatus: HttpStatusSubmitting()),
      const CoursesState(
        httpStatus: HttpStatusFailure(message: 'Error...'),
      ),
    ],
    verify: (_) {
      verify(() => coursesInterface.updateCourseName(
            courseId: 'c1',
            newCourseName: 'course123',
          )).called(1);
    },
  );

  blocTest(
    'remove course, success',
    build: () => coursesBloc,
    setUp: () {
      when(() => coursesInterface.removeCourse('c1'))
          .thenAnswer((_) async => '');
    },
    act: (CoursesBloc bloc) => bloc.add(
      CoursesEventRemoveCourse(courseId: 'c1'),
    ),
    expect: () => [
      CoursesState(httpStatus: HttpStatusSubmitting()),
      const CoursesState(
        httpStatus: HttpStatusSuccess(message: 'Pomyślnie usunięto kurs.'),
      ),
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
    act: (CoursesBloc bloc) => bloc.add(
      CoursesEventRemoveCourse(courseId: 'c1'),
    ),
    expect: () => [
      CoursesState(httpStatus: HttpStatusSubmitting()),
      const CoursesState(
        httpStatus: HttpStatusFailure(message: 'Error...'),
      ),
    ],
    verify: (_) {
      verify(() => coursesInterface.removeCourse('c1')).called(1);
    },
  );

  blocTest(
    'on course added',
    build: () => coursesBloc,
    act: (CoursesBloc bloc) => bloc.add(CoursesEventCourseAdded(
      course: const Course(id: 'c1', name: 'course 1'),
    )),
    expect: () => [
      const CoursesState(allCourses: [
        Course(id: 'c1', name: 'course 1'),
      ])
    ],
  );

  blocTest(
    'on course modified',
    build: () => coursesBloc,
    act: (CoursesBloc bloc) {
      bloc.add(CoursesEventCourseAdded(
        course: const Course(id: 'c1', name: 'course 1'),
      ));
      bloc.add(CoursesEventCourseModified(
        course: const Course(id: 'c1', name: 'course 1234'),
      ));
    },
    expect: () => [
      const CoursesState(allCourses: [
        Course(id: 'c1', name: 'course 1'),
      ]),
      const CoursesState(allCourses: [
        Course(id: 'c1', name: 'course 1234'),
      ]),
    ],
  );

  blocTest(
    'on course removed',
    build: () => coursesBloc,
    act: (CoursesBloc bloc) {
      bloc.add(CoursesEventCourseAdded(
        course: const Course(id: 'c1', name: 'course 1'),
      ));
      bloc.add(CoursesEventCourseRemoved(courseId: 'c1'));
    },
    expect: () => [
      const CoursesState(allCourses: [
        Course(id: 'c1', name: 'course 1'),
      ]),
      const CoursesState(allCourses: []),
    ],
  );
}
