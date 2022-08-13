import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/delete_group_use_case.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

class MockGetGroupUseCase extends Mock implements GetGroupUseCase {}

class MockDeleteGroupUseCase extends Mock implements DeleteGroupUseCase {}

class MockGetCourseUseCase extends Mock implements GetCourseUseCase {}

void main() {
  final getGroupUseCase = MockGetGroupUseCase();
  final deleteGroupUseCase = MockDeleteGroupUseCase();
  final getCourseUseCase = MockGetCourseUseCase();

  GroupPreviewBloc createBloc({
    Group? group,
    Course? course,
  }) {
    return GroupPreviewBloc(
      getGroupUseCase: getGroupUseCase,
      deleteGroupUseCase: deleteGroupUseCase,
      getCourseUseCase: getCourseUseCase,
      group: group,
      course: course,
    );
  }

  GroupPreviewState createState({
    BlocStatus status = const BlocStatusInProgress(),
    Group? group,
    Course? course,
  }) {
    return GroupPreviewState(
      status: status,
      group: group,
      course: course,
    );
  }

  tearDown(() {
    reset(getGroupUseCase);
    reset(deleteGroupUseCase);
    reset(getCourseUseCase);
  });

  group(
    'initialize',
    () {
      final Group group = createGroup(id: 'g1', courseId: 'c1');
      final Course course = createCourse(id: 'c1');

      blocTest(
        'initialize, should set group listener',
        build: () => createBloc(),
        setUp: () {
          when(
            () => getGroupUseCase.execute(groupId: group.id),
          ).thenAnswer((_) => Stream.value(group));
          when(
            () => getCourseUseCase.execute(courseId: group.courseId),
          ).thenAnswer((_) => Stream.value(course));
        },
        act: (GroupPreviewBloc bloc) {
          bloc.add(
            GroupPreviewEventInitialize(groupId: group.id),
          );
        },
        expect: () => [
          createState(
            group: group,
            course: course,
          ),
        ],
        verify: (_) {
          verify(
            () => getGroupUseCase.execute(groupId: group.id),
          ).called(1);
        },
      );
    },
  );

  group(
    'group updated',
    () {
      final Group updatedGroup = createGroup(id: 'g1', courseId: 'c1');
      final Course course1 = createCourse(id: 'c1');
      final Course course2 = createCourse(id: 'c2');

      setUp(() {
        when(
          () => getCourseUseCase.execute(courseId: updatedGroup.courseId),
        ).thenAnswer((_) => Stream.value(course1));
      });

      blocTest(
        'group updated, should update group and course in state if new course id is different than current course id',
        build: () => createBloc(
          course: course2,
        ),
        act: (GroupPreviewBloc bloc) {
          bloc.add(
            GroupPreviewEventGroupUpdated(group: updatedGroup),
          );
        },
        expect: () => [
          createState(
            group: updatedGroup,
            course: course1,
          ),
        ],
        verify: (_) {
          verify(
            () => getCourseUseCase.execute(courseId: updatedGroup.courseId),
          ).called(1);
        },
      );

      blocTest(
        'group updated, should update only group in state if new course id is the same as current course id',
        build: () => createBloc(
          course: course1,
        ),
        act: (GroupPreviewBloc bloc) {
          bloc.add(
            GroupPreviewEventGroupUpdated(group: updatedGroup),
          );
        },
        expect: () => [
          createState(
            group: updatedGroup,
            course: course1,
          ),
        ],
        verify: (_) {
          verifyNever(
            () => getCourseUseCase.execute(courseId: updatedGroup.courseId),
          );
        },
      );
    },
  );

  blocTest(
    'delete group, should call use case responsible for deleting group',
    build: () => createBloc(
      group: createGroup(id: 'g1'),
    ),
    setUp: () {
      when(
        () => deleteGroupUseCase.execute(groupId: 'g1'),
      ).thenAnswer((_) async => '');
    },
    act: (GroupPreviewBloc bloc) {
      bloc.add(
        GroupPreviewEventDeleteGroup(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        group: createGroup(id: 'g1'),
      ),
      createState(
        status: const BlocStatusComplete<GroupPreviewInfo>(
          info: GroupPreviewInfo.groupHasBeenDeleted,
        ),
        group: createGroup(id: 'g1'),
      ),
    ],
    verify: (_) {
      verify(
        () => deleteGroupUseCase.execute(groupId: 'g1'),
      ).called(1);
    },
  );

  blocTest(
    'delete group, should not call use case responsible for deleting group if group is null',
    build: () => createBloc(),
    setUp: () {
      when(
        () => deleteGroupUseCase.execute(groupId: any(named: 'groupId')),
      ).thenAnswer((_) async => '');
    },
    act: (GroupPreviewBloc bloc) {
      bloc.add(
        GroupPreviewEventDeleteGroup(),
      );
    },
    expect: () => [],
    verify: (_) {
      verifyNever(
        () => deleteGroupUseCase.execute(groupId: any(named: 'groupId')),
      );
    },
  );
}
