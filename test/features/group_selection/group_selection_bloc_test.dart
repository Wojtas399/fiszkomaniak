import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/load_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_groups_by_course_id_use_case.dart';
import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadAllCoursesUseCase extends Mock implements LoadAllCoursesUseCase {}

class MockGetAllCoursesUseCase extends Mock implements GetAllCoursesUseCase {}

class MockGetCourseUseCase extends Mock implements GetCourseUseCase {}

class MockGetGroupsByCourseIdUseCase extends Mock
    implements GetGroupsByCourseIdUseCase {}

class MockGetGroupUseCase extends Mock implements GetGroupUseCase {}

void main() {
  final loadAllCoursesUseCase = MockLoadAllCoursesUseCase();
  final getAllCoursesUseCase = MockGetAllCoursesUseCase();
  final getCourseUseCase = MockGetCourseUseCase();
  final getGroupsByCourseIdUseCase = MockGetGroupsByCourseIdUseCase();
  final getGroupUseCase = MockGetGroupUseCase();
  late GroupSelectionBloc bloc;

  setUp(
    () => bloc = GroupSelectionBloc(
      loadAllCoursesUseCase: loadAllCoursesUseCase,
      getAllCoursesUseCase: getAllCoursesUseCase,
      getCourseUseCase: getCourseUseCase,
      getGroupsByCourseIdUseCase: getGroupsByCourseIdUseCase,
      getGroupUseCase: getGroupUseCase,
    ),
  );

  tearDown(() {
    reset(loadAllCoursesUseCase);
    reset(getAllCoursesUseCase);
    reset(getCourseUseCase);
    reset(getGroupsByCourseIdUseCase);
    reset(getGroupUseCase);
  });

  blocTest(
    'initialize, should load all courses and assign them to state',
    build: () => bloc,
    setUp: () {
      when(() => loadAllCoursesUseCase.execute()).thenAnswer((_) async => true);
      when(
        () => getAllCoursesUseCase.execute(),
      ).thenAnswer(
        (_) => Stream.value(
          [createCourse(id: 'c1'), createCourse(id: 'c2')],
        ),
      );
    },
    act: (_) => bloc.add(GroupSelectionEventInitialize()),
    expect: () => [
      GroupSelectionState(status: const BlocStatusLoading()),
      GroupSelectionState(
        status: const BlocStatusComplete(),
        allCourses: [createCourse(id: 'c1'), createCourse(id: 'c2')],
      ),
    ],
    verify: (_) {
      verify(() => loadAllCoursesUseCase.execute()).called(1);
      verify(() => getAllCoursesUseCase.execute()).called(1);
    },
  );

  blocTest(
    'course selected, should get from repo course and groups which belong to this course and assign it all to state',
    build: () => bloc,
    setUp: () {
      when(
        () => getCourseUseCase.execute(courseId: 'c1'),
      ).thenAnswer(
        (_) => Stream.value(createCourse(id: 'c1', name: 'course 1')),
      );
      when(
        () => getGroupsByCourseIdUseCase.execute(courseId: 'c1'),
      ).thenAnswer(
        (_) => Stream.value(
          [createGroup(id: 'g1'), createGroup(id: 'g2')],
        ),
      );
    },
    act: (_) => bloc.add(GroupSelectionEventCourseSelected(courseId: 'c1')),
    expect: () => [
      GroupSelectionState(
        status: const BlocStatusComplete(),
        selectedCourse: createCourse(id: 'c1', name: 'course 1'),
        groupsFromCourse: [
          createGroup(id: 'g1'),
          createGroup(id: 'g2'),
        ],
      ),
    ],
    verify: (_) {
      verify(() => getCourseUseCase.execute(courseId: 'c1')).called(1);
      verify(
        () => getGroupsByCourseIdUseCase.execute(courseId: 'c1'),
      ).called(1);
    },
  );

  blocTest(
    'group selected, should set group listener',
    build: () => bloc,
    setUp: () {
      when(
        () => getGroupUseCase.execute(groupId: 'g1'),
      ).thenAnswer(
        (_) => Stream.value(
          createGroup(id: 'g1', name: 'group 1'),
        ),
      );
    },
    act: (_) => bloc.add(GroupSelectionEventGroupSelected(groupId: 'g1')),
    expect: () => [
      GroupSelectionState(
        status: const BlocStatusComplete(),
        selectedGroup: createGroup(id: 'g1', name: 'group 1'),
      ),
    ],
    verify: (_) {
      verify(() => getGroupUseCase.execute(groupId: 'g1')).called(1);
    },
  );

  blocTest(
    'group updated, should update group in state',
    build: () => bloc,
    act: (_) => bloc.add(
      GroupSelectionEventGroupUpdated(group: createGroup(id: 'g1')),
    ),
    expect: () => [
      GroupSelectionState(
        status: const BlocStatusComplete(),
        selectedGroup: createGroup(id: 'g1'),
      ),
    ],
  );
}
