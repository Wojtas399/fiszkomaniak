import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_event.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_bloc.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_event.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_state.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_arguments.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoursesBloc extends Mock implements CoursesBloc {}

void main() {
  final CoursesBloc coursesBloc = MockCoursesBloc();
  late CourseCreatorBloc courseCreatorBloc;

  setUp(() {
    courseCreatorBloc = CourseCreatorBloc(coursesBloc: coursesBloc);
  });

  tearDown(() {
    reset(coursesBloc);
  });

  test('initial state', () {
    final CourseCreatorState state = courseCreatorBloc.state;
    expect(state.mode, const CourseCreatorCreateMode());
    expect(state.courseName, '');
    expect(state.httpStatus, const HttpStatusInitial());
  });

  blocTest(
    'initialize, create mode',
    build: () => courseCreatorBloc,
    setUp: () {
      when(() => coursesBloc.stream).thenAnswer(
        (_) => Stream.value(const CoursesState()),
      );
    },
    act: (_) => courseCreatorBloc.add(
      CourseCreatorEventInitialize(mode: const CourseCreatorCreateMode()),
    ),
    expect: () => [
      const CourseCreatorState(mode: CourseCreatorCreateMode()),
    ],
  );

  blocTest(
    'initialize, edit mode',
    build: () => courseCreatorBloc,
    setUp: () {
      when(() => coursesBloc.stream).thenAnswer(
        (_) => Stream.value(const CoursesState()),
      );
    },
    act: (_) => courseCreatorBloc.add(
      CourseCreatorEventInitialize(
        mode: const CourseCreatorEditMode(courseId: 'c1', courseName: 'c123'),
      ),
    ),
    expect: () => [
      const CourseCreatorState(
        mode: CourseCreatorEditMode(courseId: 'c1', courseName: 'c123'),
        courseName: 'c123',
      ),
    ],
  );

  blocTest(
    'course name changed',
    build: () => courseCreatorBloc,
    act: (_) {
      courseCreatorBloc.add(CourseCreatorEventCourseNameChanged(
        courseName: 'course',
      ));
      courseCreatorBloc.add(CourseCreatorEventCourseNameChanged(
        courseName: 'course name',
      ));
    },
    expect: () => [
      const CourseCreatorState(courseName: 'course'),
      const CourseCreatorState(courseName: 'course name'),
    ],
  );

  blocTest(
    'save changes, create mode',
    build: () => courseCreatorBloc,
    act: (_) {
      courseCreatorBloc.add(CourseCreatorEventCourseNameChanged(
        courseName: 'course name',
      ));
      courseCreatorBloc.add(CourseCreatorEventSaveChanges());
    },
    expect: () => [
      const CourseCreatorState(courseName: 'course name'),
    ],
    verify: (_) {
      verify(
        () => coursesBloc.add(CoursesEventAddNewCourse(name: 'course name')),
      ).called(1);
    },
  );

  blocTest(
    'save changes, edit mode',
    build: () => courseCreatorBloc,
    setUp: () {
      when(() => coursesBloc.stream).thenAnswer(
        (_) => Stream.value(const CoursesState()),
      );
    },
    act: (_) {
      courseCreatorBloc.add(CourseCreatorEventInitialize(
        mode: const CourseCreatorEditMode(courseId: 'c1', courseName: 'c123'),
      ));
      courseCreatorBloc.add(CourseCreatorEventCourseNameChanged(
        courseName: 'course name',
      ));
      courseCreatorBloc.add(CourseCreatorEventSaveChanges());
    },
    expect: () => [
      const CourseCreatorState(
        mode: CourseCreatorEditMode(courseId: 'c1', courseName: 'c123'),
        courseName: 'c123',
      ),
      const CourseCreatorState(
        mode: CourseCreatorEditMode(courseId: 'c1', courseName: 'c123'),
        courseName: 'course name',
      ),
    ],
    verify: (_) {
      verify(
        () => coursesBloc.add(CoursesEventUpdateCourseName(
          courseId: 'c1',
          newCourseName: 'course name',
        )),
      ).called(1);
    },
  );

  blocTest(
    'http status changed',
    build: () => courseCreatorBloc,
    act: (_) => courseCreatorBloc.add(CourseCreatorEventHttpStatusChanged(
      httpStatus: const HttpStatusSuccess(),
    )),
    expect: () => [
      const CourseCreatorState(httpStatus: HttpStatusSuccess()),
    ],
  );
}
