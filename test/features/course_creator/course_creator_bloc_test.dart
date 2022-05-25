import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_bloc.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_dialogs.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_event.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_state.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_mode.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoursesBloc extends Mock implements CoursesBloc {}

class MockCourseCreatorDialogs extends Mock implements CourseCreatorDialogs {}

void main() {
  final CoursesBloc coursesBloc = MockCoursesBloc();
  final CourseCreatorDialogs courseCreatorDialogs = MockCourseCreatorDialogs();
  late CourseCreatorBloc courseCreatorBloc;
  final CoursesState coursesState = CoursesState(allCourses: [
    createCourse(id: 'c1', name: 'course 1'),
    createCourse(id: 'c2', name: 'course 2'),
  ]);

  setUp(() {
    courseCreatorBloc = CourseCreatorBloc(
      coursesBloc: coursesBloc,
      courseCreatorDialogs: courseCreatorDialogs,
    );
    when(() => coursesBloc.state).thenReturn(coursesState);
  });

  tearDown(() {
    reset(coursesBloc);
    reset(courseCreatorDialogs);
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
    'save changes, course name is already taken',
    build: () => courseCreatorBloc,
    setUp: () {
      when(
        () => courseCreatorDialogs.displayInfoAboutAlreadyTakenCourseName(),
      ).thenAnswer((_) async => '');
    },
    act: (_) {
      courseCreatorBloc.add(
        CourseCreatorEventCourseNameChanged(courseName: 'course 1'),
      );
      courseCreatorBloc.add(CourseCreatorEventSaveChanges());
    },
    expect: () => [
      const CourseCreatorState(courseName: 'course 1'),
    ],
    verify: (_) {
      verify(
        () => courseCreatorDialogs.displayInfoAboutAlreadyTakenCourseName(),
      ).called(1);
      verifyNever(
        () => coursesBloc.add(CoursesEventAddNewCourse(name: 'course 1')),
      );
    },
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
