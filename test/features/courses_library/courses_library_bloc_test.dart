import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_mode.dart';
import 'package:fiszkomaniak/features/courses_library/bloc/courses_library_bloc.dart';
import 'package:fiszkomaniak/features/courses_library/bloc/courses_library_dialogs.dart';
import 'package:fiszkomaniak/features/courses_library/bloc/courses_library_event.dart';
import 'package:fiszkomaniak/features/courses_library/bloc/courses_library_state.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoursesBloc extends Mock implements CoursesBloc {}

class MockGroupsBloc extends Mock implements GroupsBloc {}

class MockCoursesLibraryDialogs extends Mock implements CoursesLibraryDialogs {}

class MockNavigation extends Mock implements Navigation {}

void main() {
  final CoursesBloc coursesBloc = MockCoursesBloc();
  final GroupsBloc groupsBloc = MockGroupsBloc();
  final CoursesLibraryDialogs coursesLibraryDialogs =
      MockCoursesLibraryDialogs();
  final Navigation navigation = MockNavigation();
  late CoursesLibraryBloc bloc;
  final CoursesState coursesState = CoursesState(
    allCourses: [
      createCourse(id: 'c1'),
      createCourse(id: 'c2'),
    ],
  );
  final GroupsState groupsState = GroupsState(
    allGroups: [
      createGroup(id: 'g1', courseId: 'c1'),
      createGroup(id: 'g2', courseId: 'c2'),
      createGroup(id: 'g3', courseId: 'c1'),
    ],
  );

  setUp(() {
    bloc = CoursesLibraryBloc(
      coursesBloc: coursesBloc,
      groupsBloc: groupsBloc,
      coursesLibraryDialogs: coursesLibraryDialogs,
      navigation: navigation,
    );
    when(() => coursesBloc.state).thenReturn(coursesState);
    when(() => coursesBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => groupsBloc.state).thenReturn(groupsState);
  });

  tearDown(() {
    reset(coursesBloc);
    reset(groupsBloc);
    reset(coursesLibraryDialogs);
    reset(navigation);
  });

  blocTest(
    'initialize',
    build: () => bloc,
    act: (_) => bloc.add(CoursesLibraryEventInitialize()),
    expect: () => [
      CoursesLibraryState(courses: [...coursesState.allCourses]),
    ],
  );

  blocTest(
    'edit course',
    build: () => bloc,
    setUp: () {
      when(
        () => navigation.navigateToCourseCreator(
          CourseCreatorEditMode(course: coursesState.allCourses[0]),
        ),
      ).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(
      CoursesLibraryEventEditCourse(course: coursesState.allCourses[0]),
    ),
    verify: (_) {
      verify(
        () => navigation.navigateToCourseCreator(
          CourseCreatorEditMode(course: coursesState.allCourses[0]),
        ),
      ).called(1);
    },
  );

  blocTest(
    'remove course, confirmed',
    build: () => bloc,
    setUp: () {
      when(() => coursesLibraryDialogs.askForDeleteConfirmation())
          .thenAnswer((_) async => true);
    },
    act: (_) => bloc.add(CoursesLibraryEventRemoveCourse(courseId: 'c1')),
    verify: (_) {
      verify(
        () => coursesBloc.add(CoursesEventRemoveCourse(
          courseId: 'c1',
          idsOfGroupsFromCourse: const ['g1', 'g3'],
        )),
      ).called(1);
    },
  );

  blocTest(
    'remove course, cancelled',
    build: () => bloc,
    setUp: () {
      when(() => coursesLibraryDialogs.askForDeleteConfirmation())
          .thenAnswer((_) async => false);
    },
    act: (_) => bloc.add(CoursesLibraryEventRemoveCourse(courseId: 'c1')),
    verify: (_) {
      verifyNever(
        () => coursesBloc.add(CoursesEventRemoveCourse(
          courseId: 'c1',
          idsOfGroupsFromCourse: const ['g1', 'g3'],
        )),
      );
    },
  );
}
