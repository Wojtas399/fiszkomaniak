import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/features/course_groups_preview/bloc/course_groups_preview_bloc.dart';
import 'package:fiszkomaniak/features/course_groups_preview/bloc/course_groups_preview_event.dart';
import 'package:fiszkomaniak/features/course_groups_preview/bloc/course_groups_preview_state.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoursesBloc extends Mock implements CoursesBloc {}

class MockGroupsBloc extends Mock implements GroupsBloc {}

void main() {
  final CoursesBloc coursesBloc = MockCoursesBloc();
  final GroupsBloc groupsBloc = MockGroupsBloc();
  late CourseGroupsPreviewBloc bloc;
  final List<Course> courses = [
    createCourse(id: 'c1'),
    createCourse(id: 'c2'),
    createCourse(id: 'c3'),
  ];
  final List<Group> groups = [
    createGroup(id: 'g1', courseId: 'c1'),
    createGroup(id: 'g2', courseId: 'c2'),
    createGroup(id: 'g3', courseId: 'c2'),
    createGroup(id: 'g4', courseId: 'c3'),
    createGroup(id: 'g5', courseId: 'c1'),
  ];

  setUp(() {
    bloc = CourseGroupsPreviewBloc(
      coursesBloc: coursesBloc,
      groupsBloc: groupsBloc,
    );
  });

  tearDown(() {
    reset(coursesBloc);
    reset(groupsBloc);
  });

  blocTest(
    'initialize, course exists',
    build: () => bloc,
    setUp: () {
      when(() => coursesBloc.state).thenReturn(
        CoursesState(allCourses: courses),
      );
      when(() => groupsBloc.state).thenReturn(GroupsState(allGroups: groups));
      when(() => groupsBloc.stream).thenAnswer(
        (_) => Stream.value(GroupsState(allGroups: groups)),
      );
    },
    act: (_) => bloc.add(CourseGroupsPreviewEventInitialize(courseId: 'c2')),
    expect: () => [
      CourseGroupsPreviewState(course: courses[1]),
      CourseGroupsPreviewState(
        course: courses[1],
        groupsFromCourse: [groups[1], groups[2]],
      ),
    ],
  );

  blocTest(
    'initialize, course does not exist',
    build: () => bloc,
    setUp: () {
      when(() => coursesBloc.state).thenReturn(
        CoursesState(allCourses: courses),
      );
    },
    act: (_) => bloc.add(CourseGroupsPreviewEventInitialize(courseId: 'c4')),
    expect: () => [],
  );

  blocTest(
    'search value changed',
    build: () => bloc,
    act: (_) => bloc.add(
      CourseGroupsPreviewEventSearchValueChanged(searchValue: 'searchValue'),
    ),
    expect: () => [
      const CourseGroupsPreviewState(searchValue: 'searchValue'),
    ],
  );
}
