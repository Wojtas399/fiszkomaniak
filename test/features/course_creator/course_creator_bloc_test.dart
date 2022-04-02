import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_event.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_bloc.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_event.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_state.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_mode.dart';
import 'package:fiszkomaniak/models/course_model.dart';
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

  blocTest(
    'initialize, create mode',
    build: () => courseCreatorBloc,
    setUp: () {
      when(() => coursesBloc.stream).thenAnswer(
        (_) => Stream.value(CoursesState()),
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
        (_) => Stream.value(CoursesState()),
      );
    },
    act: (_) => courseCreatorBloc.add(
      CourseCreatorEventInitialize(
        mode: CourseCreatorEditMode(course: createCourse(name: 'c123')),
      ),
    ),
    expect: () => [
      CourseCreatorState(
        mode: CourseCreatorEditMode(course: createCourse(name: 'c123')),
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
        (_) => Stream.value(CoursesState()),
      );
    },
    act: (_) {
      courseCreatorBloc.add(CourseCreatorEventInitialize(
        mode: CourseCreatorEditMode(
          course: createCourse(id: 'c1', name: 'c123'),
        ),
      ));
      courseCreatorBloc.add(CourseCreatorEventCourseNameChanged(
        courseName: 'course name',
      ));
      courseCreatorBloc.add(CourseCreatorEventSaveChanges());
    },
    expect: () => [
      CourseCreatorState(
        mode: CourseCreatorEditMode(
          course: createCourse(id: 'c1', name: 'c123'),
        ),
        courseName: 'c123',
      ),
      CourseCreatorState(
        mode: CourseCreatorEditMode(
          course: createCourse(id: 'c1', name: 'c123'),
        ),
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
}