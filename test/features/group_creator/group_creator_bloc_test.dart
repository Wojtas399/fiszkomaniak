import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/load_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/add_group_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/check_group_name_usage_in_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/update_group_use_case.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_bloc.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_info.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_mode.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadAllCoursesUseCase extends Mock implements LoadAllCoursesUseCase {}

class MockGetAllCoursesUseCase extends Mock implements GetAllCoursesUseCase {}

class MockCheckGroupNameUsageInCourseUseCase extends Mock
    implements CheckGroupNameUsageInCourseUseCase {}

class MockAddGroupUseCase extends Mock implements AddGroupUseCase {}

class MockUpdateGroupUseCase extends Mock implements UpdateGroupUseCase {}

void main() {
  final loadAllCoursesUseCase = MockLoadAllCoursesUseCase();
  final getAllCoursesUseCase = MockGetAllCoursesUseCase();
  final checkGroupNameUsageInCourseUseCase =
      MockCheckGroupNameUsageInCourseUseCase();
  final addGroupUseCase = MockAddGroupUseCase();
  final updateGroupUseCase = MockUpdateGroupUseCase();
  late GroupCreatorBloc bloc;

  setUp(() {
    bloc = GroupCreatorBloc(
      loadAllCoursesUseCase: loadAllCoursesUseCase,
      getAllCoursesUseCase: getAllCoursesUseCase,
      checkGroupNameUsageInCourseUseCase: checkGroupNameUsageInCourseUseCase,
      addGroupUseCase: addGroupUseCase,
      updateGroupUseCase: updateGroupUseCase,
    );
  });

  tearDown(() {
    reset(getAllCoursesUseCase);
    reset(loadAllCoursesUseCase);
    reset(checkGroupNameUsageInCourseUseCase);
    reset(addGroupUseCase);
    reset(updateGroupUseCase);
  });

  group(
    'initialize',
    () {
      final List<Course> courses = [
        createCourse(id: 'c1'),
        createCourse(id: 'c2'),
        createCourse(id: 'c3'),
      ];
      final editMode = GroupCreatorEditMode(
        group: createGroup(
          id: 'g1',
          name: 'group 1',
          courseId: 'c1',
          nameForQuestions: 'questions',
          nameForAnswers: 'answers',
        ),
      );

      setUp(() {
        when(() => loadAllCoursesUseCase.execute()).thenAnswer((_) async => '');
        when(
          () => getAllCoursesUseCase.execute(),
        ).thenAnswer((_) => Stream.value(courses));
      });

      blocTest(
        'create mode, should set mode and all courses in state',
        build: () => bloc,
        act: (_) => bloc.add(
          GroupCreatorEventInitialize(mode: const GroupCreatorCreateMode()),
        ),
        expect: () => [
          const GroupCreatorState(status: BlocStatusLoading()),
          GroupCreatorState(
            status: const BlocStatusComplete<GroupCreatorInfo>(),
            mode: const GroupCreatorCreateMode(),
            allCourses: courses,
          ),
        ],
      );

      blocTest(
        'edit mode, should set mode, all courses, and all group params in state',
        build: () => bloc,
        act: (_) => bloc.add(GroupCreatorEventInitialize(mode: editMode)),
        expect: () => [
          const GroupCreatorState(status: BlocStatusLoading()),
          GroupCreatorState(
            status: const BlocStatusComplete<GroupCreatorInfo>(),
            mode: editMode,
            selectedCourse: courses[0],
            allCourses: courses,
            groupName: editMode.group.name,
            nameForQuestions: editMode.group.nameForQuestions,
            nameForAnswers: editMode.group.nameForAnswers,
          ),
        ],
      );
    },
  );

  blocTest(
    'on course changed, should update selected course in state',
    build: () => bloc,
    act: (_) => bloc.add(GroupCreatorEventCourseChanged(
      course: createCourse(id: 'c2'),
    )),
    expect: () => [
      GroupCreatorState(
        status: const BlocStatusComplete<GroupCreatorInfo>(),
        selectedCourse: createCourse(id: 'c2'),
      ),
    ],
  );

  blocTest(
    'on group name changed, should update group name in state',
    build: () => bloc,
    act: (_) => bloc.add(
      GroupCreatorEventGroupNameChanged(groupName: 'group 1'),
    ),
    expect: () => [
      const GroupCreatorState(
        status: BlocStatusComplete<GroupCreatorInfo>(),
        groupName: 'group 1',
      ),
    ],
  );

  blocTest(
    'on name for questions changed, should update name for questions in state',
    build: () => bloc,
    act: (_) => bloc.add(
      GroupCreatorEventNameForQuestionsChanged(nameForQuestions: 'questions'),
    ),
    expect: () => [
      const GroupCreatorState(
        status: BlocStatusComplete<GroupCreatorInfo>(),
        nameForQuestions: 'questions',
      ),
    ],
  );

  blocTest(
    'on name for answers changed, should update name for answers in state',
    build: () => bloc,
    act: (_) => bloc.add(
      GroupCreatorEventNameForAnswersChanged(nameForAnswers: 'answers'),
    ),
    expect: () => [
      const GroupCreatorState(
        status: BlocStatusComplete<GroupCreatorInfo>(),
        nameForAnswers: 'answers',
      ),
    ],
  );

  group(
    'submit, create mode',
    () {
      void setGroupParams() {
        bloc.add(GroupCreatorEventCourseChanged(
          course: createCourse(id: 'c1'),
        ));
        bloc.add(GroupCreatorEventGroupNameChanged(groupName: 'group 1'));
        bloc.add(GroupCreatorEventNameForQuestionsChanged(
          nameForQuestions: 'questions',
        ));
        bloc.add(GroupCreatorEventNameForAnswersChanged(
          nameForAnswers: 'answers',
        ));
      }

      final state1 = GroupCreatorState(
        status: const BlocStatusComplete<GroupCreatorInfo>(),
        selectedCourse: createCourse(id: 'c1'),
      );
      final state2 = GroupCreatorState(
        status: const BlocStatusComplete<GroupCreatorInfo>(),
        selectedCourse: createCourse(id: 'c1'),
        groupName: 'group 1',
      );
      final state3 = GroupCreatorState(
        status: const BlocStatusComplete<GroupCreatorInfo>(),
        selectedCourse: createCourse(id: 'c1'),
        groupName: 'group 1',
        nameForQuestions: 'questions',
      );
      final state4 = GroupCreatorState(
        status: const BlocStatusComplete<GroupCreatorInfo>(),
        selectedCourse: createCourse(id: 'c1'),
        groupName: 'group 1',
        nameForQuestions: 'questions',
        nameForAnswers: 'answers',
      );

      blocTest(
        'group name is already taken, should emit appropriate info type',
        build: () => bloc,
        setUp: () {
          when(
            () => checkGroupNameUsageInCourseUseCase.execute(
              groupName: 'group 1',
              courseId: 'c1',
            ),
          ).thenAnswer((_) async => true);
        },
        act: (_) {
          setGroupParams();
          bloc.add(GroupCreatorEventSubmit());
        },
        expect: () => [
          state1,
          state2,
          state3,
          state4,
          state4.copyWith(status: const BlocStatusLoading()),
          state4.copyWith(
            status: const BlocStatusComplete<GroupCreatorInfo>(
              info: GroupCreatorInfoGroupNameIsAlreadyTaken(),
            ),
          ),
        ],
      );

      blocTest(
        'should call add group use case and emit appropriate info type',
        build: () => bloc,
        setUp: () {
          when(
            () => checkGroupNameUsageInCourseUseCase.execute(
              groupName: 'group 1',
              courseId: 'c1',
            ),
          ).thenAnswer((_) async => false);
          when(
            () => addGroupUseCase.execute(
              name: 'group 1',
              courseId: 'c1',
              nameForQuestions: 'questions',
              nameForAnswers: 'answers',
            ),
          ).thenAnswer((_) async => '');
        },
        act: (_) {
          setGroupParams();
          bloc.add(GroupCreatorEventSubmit());
        },
        expect: () => [
          state1,
          state2,
          state3,
          state4,
          state4.copyWith(status: const BlocStatusLoading()),
          state4.copyWith(
            status: const BlocStatusComplete<GroupCreatorInfo>(
              info: GroupCreatorInfoGroupHasBeenAdded(),
            ),
          ),
        ],
        verify: (_) {
          verify(
            () => addGroupUseCase.execute(
              name: 'group 1',
              courseId: 'c1',
              nameForQuestions: 'questions',
              nameForAnswers: 'answers',
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'submit, edit mode',
    () {
      final editMode = GroupCreatorEditMode(
        group: createGroup(
          id: 'g1',
          name: 'group 1',
          courseId: 'c1',
          nameForQuestions: 'questions',
          nameForAnswers: 'answers',
        ),
      );
      final stateAfterInitialization = GroupCreatorState(
        status: const BlocStatusComplete<GroupCreatorInfo>(),
        mode: editMode,
        selectedCourse: createCourse(id: 'c1'),
        allCourses: [createCourse(id: 'c1')],
        groupName: editMode.group.name,
        nameForQuestions: editMode.group.nameForQuestions,
        nameForAnswers: editMode.group.nameForAnswers,
      );

      blocTest(
        'submit, edit mode, should call update group use case and emit appropriate info type',
        build: () => bloc,
        setUp: () {
          when(
            () => loadAllCoursesUseCase.execute(),
          ).thenAnswer((_) async => '');
          when(
            () => getAllCoursesUseCase.execute(),
          ).thenAnswer((_) => Stream.value([createCourse(id: 'c1')]));
          when(
            () => checkGroupNameUsageInCourseUseCase.execute(
              groupName: 'group 1',
              courseId: 'c1',
            ),
          ).thenAnswer((_) async => false);
          when(
            () => updateGroupUseCase.execute(
              groupId: 'g1',
              name: 'group 1',
              courseId: 'c1',
              nameForQuestions: 'questions',
              nameForAnswers: 'answers',
            ),
          ).thenAnswer((_) async => '');
        },
        act: (_) async {
          bloc.add(GroupCreatorEventInitialize(mode: editMode));
          await Future.delayed(const Duration(seconds: 2));
          bloc.add(GroupCreatorEventSubmit());
        },
        expect: () => [
          const GroupCreatorState(status: BlocStatusLoading()),
          stateAfterInitialization,
          stateAfterInitialization.copyWith(status: const BlocStatusLoading()),
          stateAfterInitialization.copyWith(
            status: const BlocStatusComplete<GroupCreatorInfo>(
              info: GroupCreatorInfoGroupHasBeenUpdated(groupId: 'g1'),
            ),
          ),
        ],
      );
    },
  );
}
