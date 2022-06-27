import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/remove_group_use_case.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_bloc.dart';
import 'package:fiszkomaniak/features/group_preview/group_preview_dialogs.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetGroupUseCase extends Mock implements GetGroupUseCase {}

class MockRemoveGroupUseCase extends Mock implements RemoveGroupUseCase {}

class MockGetCourseUseCase extends Mock implements GetCourseUseCase {}

class MockGroupPreviewDialogs extends Mock implements GroupPreviewDialogs {}

void main() {
  final getGroupUseCase = MockGetGroupUseCase();
  final removeGroupUseCase = MockRemoveGroupUseCase();
  final getCourseUseCase = MockGetCourseUseCase();
  final groupPreviewDialogs = MockGroupPreviewDialogs();
  late GroupPreviewBloc bloc;

  setUp(() {
    bloc = GroupPreviewBloc(
      getGroupUseCase: getGroupUseCase,
      removeGroupUseCase: removeGroupUseCase,
      getCourseUseCase: getCourseUseCase,
      groupPreviewDialogs: groupPreviewDialogs,
    );
  });

  tearDown(() {
    reset(getGroupUseCase);
    reset(removeGroupUseCase);
    reset(getCourseUseCase);
    reset(groupPreviewDialogs);
  });

  blocTest(
    'initialize, should set group listener',
    build: () => bloc,
    setUp: () {
      when(
        () => getGroupUseCase.execute(groupId: 'g1'),
      ).thenAnswer(
        (_) => Stream.value(
          createGroup(id: 'g1', courseId: 'c1', name: 'group 1'),
        ),
      );
      when(
        () => getCourseUseCase.execute(courseId: 'c1'),
      ).thenAnswer(
        (_) => Stream.value(
          createCourse(id: 'c1', name: 'course 1'),
        ),
      );
    },
    act: (_) => bloc.add(GroupPreviewEventInitialize(groupId: 'g1')),
    expect: () => [
      GroupPreviewState(
        status: const BlocStatusComplete<GroupPreviewInfoType>(),
        group: createGroup(id: 'g1', courseId: 'c1', name: 'group 1'),
      ),
      GroupPreviewState(
        status: const BlocStatusComplete<GroupPreviewInfoType>(),
        group: createGroup(id: 'g1', courseId: 'c1', name: 'group 1'),
        course: createCourse(id: 'c1', name: 'course 1'),
      ),
    ],
  );

  blocTest(
    'group updated, should update group in state',
    build: () => bloc,
    act: (_) => bloc.add(
      GroupPreviewEventGroupUpdated(
        group: createGroup(id: 'g1', courseId: 'c1', name: 'group 1'),
      ),
    ),
    expect: () => [
      GroupPreviewState(
        status: const BlocStatusComplete<GroupPreviewInfoType>(),
        group: createGroup(id: 'g1', courseId: 'c1', name: 'group 1'),
      )
    ],
  );

  blocTest(
    'course changed, should get course from repo and update state',
    build: () => bloc,
    setUp: () {
      when(
        () => getCourseUseCase.execute(courseId: 'c1'),
      ).thenAnswer(
        (_) => Stream.value(createCourse(id: 'c1', name: 'course 1')),
      );
    },
    act: (_) => bloc.add(GroupPreviewEventCourseChanged(courseId: 'c1')),
    expect: () => [
      GroupPreviewState(
        status: const BlocStatusComplete<GroupPreviewInfoType>(),
        course: createCourse(id: 'c1', name: 'course 1'),
      )
    ],
    verify: (_) {
      verify(() => getCourseUseCase.execute(courseId: 'c1')).called(1);
    },
  );

  blocTest(
    'remove group, cancelled, should not remove group',
    build: () => bloc,
    setUp: () {
      when(
        () => groupPreviewDialogs.askForDeleteConfirmation(),
      ).thenAnswer((_) async => false);
    },
    act: (_) {
      bloc.add(GroupPreviewEventGroupUpdated(group: createGroup(id: 'g1')));
      bloc.add(GroupPreviewEventRemoveGroup());
    },
    verify: (_) {
      verify(() => groupPreviewDialogs.askForDeleteConfirmation()).called(1);
      verifyNever(() => removeGroupUseCase.execute(groupId: 'g1'));
    },
  );

  blocTest(
    'remove group, confirmed, should remove group',
    build: () => bloc,
    setUp: () {
      when(
        () => groupPreviewDialogs.askForDeleteConfirmation(),
      ).thenAnswer((_) async => true);
      when(
        () => removeGroupUseCase.execute(groupId: 'g1'),
      ).thenAnswer((_) async => '');
    },
    act: (_) {
      bloc.add(GroupPreviewEventGroupUpdated(group: createGroup(id: 'g1')));
      bloc.add(GroupPreviewEventRemoveGroup());
    },
    expect: () => [
      GroupPreviewState(
        status: const BlocStatusComplete<GroupPreviewInfoType>(),
        group: createGroup(id: 'g1'),
      ),
      GroupPreviewState(
        status: const BlocStatusLoading(),
        group: createGroup(id: 'g1'),
      ),
      GroupPreviewState(
        status: const BlocStatusComplete<GroupPreviewInfoType>(
          info: GroupPreviewInfoType.groupHasBeenRemoved,
        ),
        group: createGroup(id: 'g1'),
      ),
    ],
    verify: (_) {
      verify(() => groupPreviewDialogs.askForDeleteConfirmation()).called(1);
      verify(() => removeGroupUseCase.execute(groupId: 'g1')).called(1);
    },
  );
}
