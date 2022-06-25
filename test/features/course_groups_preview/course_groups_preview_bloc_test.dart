import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/components/group_item/group_item.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_groups_by_course_id_use_case.dart';
import 'package:fiszkomaniak/features/course_groups_preview/bloc/course_groups_preview_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCourseUseCase extends Mock implements GetCourseUseCase {}

class MockGetGroupsByCourseIdUseCase extends Mock
    implements GetGroupsByCourseIdUseCase {}

void main() {
  final getCourseUseCase = MockGetCourseUseCase();
  final getGroupsByCourseIdUseCase = MockGetGroupsByCourseIdUseCase();
  late CourseGroupsPreviewBloc bloc;

  setUp(() {
    bloc = CourseGroupsPreviewBloc(
      getCourseUseCase: getCourseUseCase,
      getGroupsByCourseIdUseCase: getGroupsByCourseIdUseCase,
    );
  });

  tearDown(() {
    reset(getCourseUseCase);
    reset(getGroupsByCourseIdUseCase);
  });

  blocTest(
    'initialize, should set course name and groups listeners',
    build: () => bloc,
    setUp: () {
      when(
        () => getCourseUseCase.execute(courseId: 'c1'),
      ).thenAnswer((_) => const Stream.empty());
      when(
        () => getGroupsByCourseIdUseCase.execute(courseId: 'c1'),
      ).thenAnswer((_) => const Stream.empty());
    },
    act: (_) => bloc.add(CourseGroupsPreviewEventInitialize(courseId: 'c1')),
    verify: (_) {
      verify(() => getCourseUseCase.execute(courseId: 'c1')).called(1);
      verify(
        () => getGroupsByCourseIdUseCase.execute(courseId: 'c1'),
      ).called(1);
    },
  );

  blocTest(
    'course name updated, should update course name in state',
    build: () => bloc,
    act: (_) => bloc.add(
      CourseGroupsPreviewEventCourseNameUpdated(
        updatedCourseName: 'new course name',
      ),
    ),
    expect: () => [
      CourseGroupsPreviewState(courseName: 'new course name'),
    ],
  );

  blocTest(
    'groups updated, should update groups in state',
    build: () => bloc,
    act: (_) => bloc.add(
      CourseGroupsPreviewEventGroupsUpdated(updatedGroups: [
        createGroupItemParams(id: 'g1', name: 'group 1'),
        createGroupItemParams(id: 'g2', name: 'group 2'),
      ]),
    ),
    expect: () => [
      CourseGroupsPreviewState(
        groupsFromCourse: [
          createGroupItemParams(id: 'g1', name: 'group 1'),
          createGroupItemParams(id: 'g2', name: 'group 2'),
        ],
      ),
    ],
  );

  blocTest(
    'search value changed, should update search value in state',
    build: () => bloc,
    act: (_) => bloc.add(
      CourseGroupsPreviewEventSearchValueChanged(
        searchValue: 'new search value',
      ),
    ),
    expect: () => [
      CourseGroupsPreviewState(searchValue: 'new search value'),
    ],
  );
}
