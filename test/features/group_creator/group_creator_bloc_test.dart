import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/load_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/add_group_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/check_group_name_usage_in_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/update_group_use_case.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_bloc.dart';
import 'package:fiszkomaniak/features/group_creator/group_creator_mode.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

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

  GroupCreatorBloc createBloc({
    GroupCreatorMode mode = const GroupCreatorCreateMode(),
    Course? selectedCourse,
    String groupName = '',
    String nameForQuestions = '',
    String nameForAnswers = '',
  }) {
    return GroupCreatorBloc(
      loadAllCoursesUseCase: loadAllCoursesUseCase,
      getAllCoursesUseCase: getAllCoursesUseCase,
      checkGroupNameUsageInCourseUseCase: checkGroupNameUsageInCourseUseCase,
      addGroupUseCase: addGroupUseCase,
      updateGroupUseCase: updateGroupUseCase,
      mode: mode,
      selectedCourse: selectedCourse,
      groupName: groupName,
      nameForQuestions: nameForQuestions,
      nameForAnswers: nameForAnswers,
    );
  }

  GroupCreatorState createState({
    GroupCreatorMode mode = const GroupCreatorCreateMode(),
    BlocStatus status = const BlocStatusInProgress(),
    Course? selectedCourse,
    List<Course> allCourses = const [],
    String groupName = '',
    String nameForQuestions = '',
    String nameForAnswers = '',
  }) {
    return GroupCreatorState(
      mode: mode,
      status: status,
      selectedCourse: selectedCourse,
      allCourses: allCourses,
      groupName: groupName,
      nameForQuestions: nameForQuestions,
      nameForAnswers: nameForAnswers,
    );
  }

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
        build: () => createBloc(),
        act: (GroupCreatorBloc bloc) {
          bloc.add(
            GroupCreatorEventInitialize(
              mode: const GroupCreatorCreateMode(),
            ),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusComplete(),
            mode: const GroupCreatorCreateMode(),
            allCourses: courses,
          ),
        ],
      );

      blocTest(
        'edit mode, should set mode, all courses, and all group params in state',
        build: () => createBloc(),
        act: (GroupCreatorBloc bloc) {
          bloc.add(
            GroupCreatorEventInitialize(mode: editMode),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusComplete(),
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
    build: () => createBloc(),
    act: (GroupCreatorBloc bloc) {
      bloc.add(
        GroupCreatorEventCourseChanged(
          course: createCourse(id: 'c2'),
        ),
      );
    },
    expect: () => [
      createState(
        selectedCourse: createCourse(id: 'c2'),
      ),
    ],
  );

  blocTest(
    'on group name changed, should update group name in state',
    build: () => createBloc(),
    act: (GroupCreatorBloc bloc) {
      bloc.add(
        GroupCreatorEventGroupNameChanged(
          groupName: 'group 1',
        ),
      );
    },
    expect: () => [
      createState(
        groupName: 'group 1',
      ),
    ],
  );

  blocTest(
    'on name for questions changed, should update name for questions in state',
    build: () => createBloc(),
    act: (GroupCreatorBloc bloc) {
      bloc.add(
        GroupCreatorEventNameForQuestionsChanged(
          nameForQuestions: 'questions',
        ),
      );
    },
    expect: () => [
      createState(
        nameForQuestions: 'questions',
      ),
    ],
  );

  blocTest(
    'on name for answers changed, should update name for answers in state',
    build: () => createBloc(),
    act: (GroupCreatorBloc bloc) {
      bloc.add(
        GroupCreatorEventNameForAnswersChanged(
          nameForAnswers: 'answers',
        ),
      );
    },
    expect: () => [
      createState(
        nameForAnswers: 'answers',
      ),
    ],
  );

  group(
    'submit, create mode',
    () {
      final Course selectedCourse = createCourse(id: 'c1');
      const String groupName = 'group 1';
      const String nameForQuestions = 'questions';
      const String nameForAnswers = 'answers';

      blocTest(
        'should emit appropriate error if group name is already taken',
        build: () => createBloc(
          selectedCourse: selectedCourse,
          groupName: groupName,
        ),
        setUp: () {
          when(
            () => checkGroupNameUsageInCourseUseCase.execute(
              groupName: groupName,
              courseId: selectedCourse.id,
            ),
          ).thenAnswer((_) async => true);
        },
        act: (GroupCreatorBloc bloc) {
          bloc.add(
            GroupCreatorEventSubmit(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            selectedCourse: selectedCourse,
            groupName: groupName,
          ),
          createState(
            status: const BlocStatusError<GroupCreatorError>(
              error: GroupCreatorError.groupNameIsAlreadyTaken,
            ),
            selectedCourse: selectedCourse,
            groupName: groupName,
          ),
        ],
      );

      blocTest(
        'should call use case responsible for adding new group',
        build: () => createBloc(
          selectedCourse: selectedCourse,
          groupName: groupName,
          nameForQuestions: nameForQuestions,
          nameForAnswers: nameForAnswers,
        ),
        setUp: () {
          when(
            () => checkGroupNameUsageInCourseUseCase.execute(
              groupName: groupName,
              courseId: selectedCourse.id,
            ),
          ).thenAnswer((_) async => false);
          when(
            () => addGroupUseCase.execute(
              name: groupName,
              courseId: selectedCourse.id,
              nameForQuestions: nameForQuestions,
              nameForAnswers: nameForAnswers,
            ),
          ).thenAnswer((_) async => '');
        },
        act: (GroupCreatorBloc bloc) {
          bloc.add(
            GroupCreatorEventSubmit(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            selectedCourse: selectedCourse,
            groupName: groupName,
            nameForQuestions: nameForQuestions,
            nameForAnswers: nameForAnswers,
          ),
          createState(
            status: const BlocStatusComplete<GroupCreatorInfo>(
              info: GroupCreatorInfo.groupHasBeenAdded,
            ),
            selectedCourse: selectedCourse,
            groupName: groupName,
            nameForQuestions: nameForQuestions,
            nameForAnswers: nameForAnswers,
          ),
        ],
        verify: (_) {
          verify(
            () => addGroupUseCase.execute(
              name: groupName,
              courseId: selectedCourse.id,
              nameForQuestions: nameForQuestions,
              nameForAnswers: nameForAnswers,
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
      final Course selectedCourse = createCourse(id: editMode.group.courseId);

      blocTest(
        'should call use case responsible for updating group',
        build: () => createBloc(
          mode: editMode,
          selectedCourse: selectedCourse,
          groupName: 'new group name',
          nameForQuestions: editMode.group.nameForQuestions,
          nameForAnswers: 'new name for answers',
        ),
        setUp: () {
          when(
            () => checkGroupNameUsageInCourseUseCase.execute(
              groupName: 'new group name',
              courseId: selectedCourse.id,
            ),
          ).thenAnswer((_) async => false);
          when(
            () => updateGroupUseCase.execute(
              groupId: editMode.group.id,
              name: 'new group name',
              courseId: selectedCourse.id,
              nameForQuestions: editMode.group.nameForQuestions,
              nameForAnswers: 'new name for answers',
            ),
          ).thenAnswer((_) async => '');
        },
        act: (GroupCreatorBloc bloc) async {
          bloc.add(
            GroupCreatorEventSubmit(),
          );
        },
        expect: () => [
          createState(
            mode: editMode,
            status: const BlocStatusLoading(),
            selectedCourse: selectedCourse,
            groupName: 'new group name',
            nameForQuestions: editMode.group.nameForQuestions,
            nameForAnswers: 'new name for answers',
          ),
          createState(
            mode: editMode,
            status: const BlocStatusComplete<GroupCreatorInfo>(
              info: GroupCreatorInfo.groupHasBeenEdited,
            ),
            selectedCourse: selectedCourse,
            groupName: 'new group name',
            nameForQuestions: editMode.group.nameForQuestions,
            nameForAnswers: 'new name for answers',
          ),
        ],
      );
    },
  );
}
