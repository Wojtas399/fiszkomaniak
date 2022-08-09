import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/load_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_groups_by_course_id_use_case.dart';
import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

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

  GroupSelectionBloc createBloc() {
    return GroupSelectionBloc(
      loadAllCoursesUseCase: loadAllCoursesUseCase,
      getAllCoursesUseCase: getAllCoursesUseCase,
      getCourseUseCase: getCourseUseCase,
      getGroupsByCourseIdUseCase: getGroupsByCourseIdUseCase,
      getGroupUseCase: getGroupUseCase,
    );
  }

  GroupSelectionState createState({
    BlocStatus status = const BlocStatusInProgress(),
    List<Course> allCourses = const [],
    List<Group> groupsFromCourse = const [],
    Course? selectedCourse,
    Group? selectedGroup,
  }) {
    return GroupSelectionState(
      status: status,
      allCourses: allCourses,
      groupsFromCourse: groupsFromCourse,
      selectedCourse: selectedCourse,
      selectedGroup: selectedGroup,
    );
  }

  tearDown(() {
    reset(loadAllCoursesUseCase);
    reset(getAllCoursesUseCase);
    reset(getCourseUseCase);
    reset(getGroupsByCourseIdUseCase);
    reset(getGroupUseCase);
  });

  group(
    'initialize',
    () {
      final List<Course> courses = [
        createCourse(id: 'c1'),
        createCourse(id: 'c2'),
      ];

      blocTest(
        'should load all courses and assign them to state',
        build: () => createBloc(),
        setUp: () {
          when(
            () => loadAllCoursesUseCase.execute(),
          ).thenAnswer((_) async => '');
          when(
            () => getAllCoursesUseCase.execute(),
          ).thenAnswer((_) => Stream.value(courses));
        },
        act: (GroupSelectionBloc bloc) {
          bloc.add(
            GroupSelectionEventInitialize(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusComplete(),
            allCourses: courses,
          ),
        ],
        verify: (_) {
          verify(
            () => loadAllCoursesUseCase.execute(),
          ).called(1);
        },
      );
    },
  );

  group(
    'course selected',
    () {
      final Course selectedCourse = createCourse(id: 'c1');
      final List<Group> groupsFromCourse = [
        createGroup(id: 'g1', courseId: 'c1'),
        createGroup(id: 'g2', courseId: 'c1'),
      ];

      blocTest(
        'should load course and groups from this course and assign them to state',
        build: () => createBloc(),
        setUp: () {
          when(
            () => getCourseUseCase.execute(courseId: selectedCourse.id),
          ).thenAnswer((_) => Stream.value(selectedCourse));
          when(
            () => getGroupsByCourseIdUseCase.execute(
              courseId: selectedCourse.id,
            ),
          ).thenAnswer((_) => Stream.value(groupsFromCourse));
        },
        act: (GroupSelectionBloc bloc) {
          bloc.add(
            GroupSelectionEventCourseSelected(courseId: selectedCourse.id),
          );
        },
        expect: () => [
          createState(
            selectedCourse: selectedCourse,
            groupsFromCourse: groupsFromCourse,
          ),
        ],
        verify: (_) {
          verify(
            () => getCourseUseCase.execute(courseId: selectedCourse.id),
          ).called(1);
          verify(
            () => getGroupsByCourseIdUseCase.execute(
              courseId: selectedCourse.id,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'group selected',
    () {
      final Group selectedGroup = createGroup(id: 'g1');

      blocTest(
        'should set new group listener',
        build: () => createBloc(),
        setUp: () {
          when(
            () => getGroupUseCase.execute(groupId: selectedGroup.id),
          ).thenAnswer((_) => Stream.value(selectedGroup));
        },
        act: (GroupSelectionBloc bloc) {
          bloc.add(
            GroupSelectionEventGroupSelected(groupId: selectedGroup.id),
          );
        },
        expect: () => [
          createState(
            selectedGroup: selectedGroup,
          ),
        ],
        verify: (_) {
          verify(
            () => getGroupUseCase.execute(groupId: selectedGroup.id),
          ).called(1);
        },
      );
    },
  );

  group(
    'group updated',
    () {
      final Group updatedGroup = createGroup(id: 'g1');

      blocTest(
        'should update group in state',
        build: () => createBloc(),
        act: (GroupSelectionBloc bloc) {
          bloc.add(
            GroupSelectionEventGroupUpdated(group: updatedGroup),
          );
        },
        expect: () => [
          createState(
            selectedGroup: updatedGroup,
          ),
        ],
      );
    },
  );
}
