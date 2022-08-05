import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_groups_by_course_id_use_case.dart';
import 'package:fiszkomaniak/features/course_groups_preview/bloc/course_groups_preview_bloc.dart';

class MockGetCourseUseCase extends Mock implements GetCourseUseCase {}

class MockGetGroupsByCourseIdUseCase extends Mock
    implements GetGroupsByCourseIdUseCase {}

void main() {
  final getCourseUseCase = MockGetCourseUseCase();
  final getGroupsByCourseIdUseCase = MockGetGroupsByCourseIdUseCase();

  CourseGroupsPreviewBloc createBloc() {
    return CourseGroupsPreviewBloc(
      getCourseUseCase: getCourseUseCase,
      getGroupsByCourseIdUseCase: getGroupsByCourseIdUseCase,
    );
  }

  CourseGroupsPreviewState createState({
    String courseName = '',
    String searchValue = '',
    List<Group> groupsFromCourse = const [],
  }) {
    return CourseGroupsPreviewState(
      courseName: courseName,
      searchValue: searchValue,
      groupsFromCourse: groupsFromCourse,
    );
  }

  tearDown(() {
    reset(getCourseUseCase);
    reset(getGroupsByCourseIdUseCase);
  });

  group(
    'initialize',
    () {
      final Course course = createCourse(id: 'c1', name: 'course 1');
      final List<Group> groupsFromCourse = [
        createGroup(id: 'g1', courseId: 'c1'),
        createGroup(id: 'g2', courseId: 'c1'),
      ];

      blocTest(
        'should set listener for course name and groups from course',
        build: () => createBloc(),
        setUp: () {
          when(
            () => getCourseUseCase.execute(courseId: course.id),
          ).thenAnswer((_) => Stream.value(course));
          when(
            () => getGroupsByCourseIdUseCase.execute(courseId: course.id),
          ).thenAnswer((_) => Stream.value(groupsFromCourse));
        },
        act: (CourseGroupsPreviewBloc bloc) {
          bloc.add(
            CourseGroupsPreviewEventInitialize(courseId: course.id),
          );
        },
        expect: () => [
          createState(
            courseName: course.name,
            groupsFromCourse: groupsFromCourse,
          ),
        ],
        verify: (_) {
          verify(
            () => getCourseUseCase.execute(courseId: course.id),
          ).called(1);
          verify(
            () => getGroupsByCourseIdUseCase.execute(courseId: course.id),
          ).called(1);
        },
      );
    },
  );

  group(
    'listened params updated',
    () {
      const String courseName = 'course 1';
      final List<Group> groupsFromCourse = [
        createGroup(id: 'g1', courseId: 'c1'),
        createGroup(id: 'g2', courseId: 'c1'),
      ];

      blocTest(
        'should update course name and groups from course in state',
        build: () => createBloc(),
        act: (CourseGroupsPreviewBloc bloc) {
          bloc.add(
            CourseGroupsPreviewEventListenedParamsUpdated(
              params: CourseGroupsPreviewStateListenedParams(
                courseName: courseName,
                groupsFromCourse: groupsFromCourse,
              ),
            ),
          );
        },
        expect: () => [
          createState(
            courseName: courseName,
            groupsFromCourse: groupsFromCourse,
          ),
        ],
      );
    },
  );

  blocTest(
    'search value changed, should update search value in state',
    build: () => createBloc(),
    act: (CourseGroupsPreviewBloc bloc) {
      bloc.add(
        CourseGroupsPreviewEventSearchValueChanged(
          searchValue: 'new search value',
        ),
      );
    },
    expect: () => [
      createState(searchValue: 'new search value'),
    ],
  );
}
