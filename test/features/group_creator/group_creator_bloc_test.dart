import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_bloc.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_dialogs.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_event.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_mode.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_state.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoursesBloc extends Mock implements CoursesBloc {}

class MockGroupsBloc extends Mock implements GroupsBloc {}

class MockGroupCreatorDialogs extends Mock implements GroupCreatorDialogs {}

void main() {
  final CoursesBloc coursesBloc = MockCoursesBloc();
  final GroupsBloc groupsBloc = MockGroupsBloc();
  final GroupCreatorDialogs groupCreatorDialogs = MockGroupCreatorDialogs();
  late GroupCreatorBloc bloc;
  final CoursesState coursesState = CoursesState(
    allCourses: [
      createCourse(id: 'c1'),
      createCourse(id: 'c2'),
      createCourse(id: 'c3'),
    ],
  );
  final GroupsState groupsState = GroupsState(
    allGroups: [
      createGroup(id: 'g1', courseId: 'c1', name: 'group1'),
      createGroup(id: 'g2', courseId: 'c1', name: 'group2'),
    ],
  );

  setUp(() {
    bloc = GroupCreatorBloc(
      coursesBloc: coursesBloc,
      groupsBloc: groupsBloc,
      groupCreatorDialogs: groupCreatorDialogs,
    );
    when(() => coursesBloc.state).thenReturn(coursesState);
    when(() => groupsBloc.state).thenReturn(groupsState);
  });

  tearDown(() {
    reset(coursesBloc);
    reset(groupsBloc);
    reset(groupCreatorDialogs);
  });

  blocTest(
    'initialize, create mode',
    build: () => bloc,
    act: (_) => bloc.add(
      GroupCreatorEventInitialize(mode: const GroupCreatorCreateMode()),
    ),
    expect: () => [
      GroupCreatorState(
        mode: const GroupCreatorCreateMode(),
        allCourses: coursesState.allCourses,
      ),
    ],
  );

  blocTest(
    'initialize, edit mode',
    build: () => bloc,
    act: (_) => bloc.add(
      GroupCreatorEventInitialize(
        mode: GroupCreatorEditMode(group: groupsState.allGroups[0]),
      ),
    ),
    expect: () => [
      GroupCreatorState(
        mode: GroupCreatorEditMode(group: groupsState.allGroups[0]),
        selectedCourse: coursesState.allCourses[0],
        allCourses: coursesState.allCourses,
        groupName: groupsState.allGroups[0].name,
        nameForQuestions: groupsState.allGroups[0].nameForQuestions,
        nameForAnswers: groupsState.allGroups[0].nameForAnswers,
      ),
    ],
  );

  blocTest(
    'course changed',
    build: () => bloc,
    act: (_) => bloc.add(
      GroupCreatorEventCourseChanged(course: createCourse(id: 'c2')),
    ),
    expect: () => [
      GroupCreatorState(selectedCourse: createCourse(id: 'c2')),
    ],
  );

  blocTest(
    'group name changed',
    build: () => bloc,
    act: (_) => bloc.add(
      GroupCreatorEventGroupNameChanged(groupName: 'groupName'),
    ),
    expect: () => [
      const GroupCreatorState(groupName: 'groupName'),
    ],
  );

  blocTest(
    'name for questions changed',
    build: () => bloc,
    act: (_) => bloc.add(
      GroupCreatorEventNameForQuestionsChanged(nameForQuestions: 'questions'),
    ),
    expect: () => [
      const GroupCreatorState(nameForQuestions: 'questions'),
    ],
  );

  blocTest(
    'name for answers changed',
    build: () => bloc,
    act: (_) => bloc.add(
      GroupCreatorEventNameForAnswersChanged(nameForAnswers: 'answers'),
    ),
    expect: () => [
      const GroupCreatorState(nameForAnswers: 'answers'),
    ],
  );

  blocTest(
    'submit, group name is already taken',
    build: () => bloc,
    setUp: () {
      when(
        () =>
            groupCreatorDialogs.displayInfoAboutAlreadyTakenGroupNameInCourse(),
      ).thenAnswer((_) async => '');
    },
    act: (_) {
      bloc.add(GroupCreatorEventGroupNameChanged(groupName: 'group1'));
      bloc.add(
        GroupCreatorEventCourseChanged(course: coursesState.allCourses[0]),
      );
      bloc.add(GroupCreatorEventSubmit());
    },
    expect: () => [
      const GroupCreatorState(groupName: 'group1'),
      GroupCreatorState(
        groupName: 'group1',
        selectedCourse: coursesState.allCourses[0],
      ),
    ],
    verify: (_) {
      verify(
        () =>
            groupCreatorDialogs.displayInfoAboutAlreadyTakenGroupNameInCourse(),
      ).called(1);
      verifyNever(
        () => groupsBloc.add(
          GroupsEventAddGroup(
            name: 'name',
            courseId: 'c1',
            nameForQuestions: '',
            nameForAnswers: '',
          ),
        ),
      );
    },
  );

  blocTest(
    'submit, create mode',
    build: () => bloc,
    act: (_) {
      bloc.add(GroupCreatorEventGroupNameChanged(groupName: 'name'));
      bloc.add(GroupCreatorEventCourseChanged(course: createCourse(id: 'c1')));
      bloc.add(GroupCreatorEventNameForQuestionsChanged(
        nameForQuestions: 'nameForQuestions',
      ));
      bloc.add(GroupCreatorEventNameForAnswersChanged(
        nameForAnswers: 'nameForAnswers',
      ));
      bloc.add(GroupCreatorEventSubmit());
    },
    expect: () => [
      const GroupCreatorState(groupName: 'name'),
      GroupCreatorState(
        groupName: 'name',
        selectedCourse: createCourse(id: 'c1'),
      ),
      GroupCreatorState(
        groupName: 'name',
        selectedCourse: createCourse(id: 'c1'),
        nameForQuestions: 'nameForQuestions',
      ),
      GroupCreatorState(
        groupName: 'name',
        selectedCourse: createCourse(id: 'c1'),
        nameForQuestions: 'nameForQuestions',
        nameForAnswers: 'nameForAnswers',
      ),
    ],
    verify: (_) {
      verify(
        () => groupsBloc.add(
          GroupsEventAddGroup(
            name: 'name',
            courseId: 'c1',
            nameForQuestions: 'nameForQuestions',
            nameForAnswers: 'nameForAnswers',
          ),
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, edit mode',
    build: () => bloc,
    act: (_) {
      bloc.add(
        GroupCreatorEventInitialize(
          mode: GroupCreatorEditMode(group: groupsState.allGroups[0]),
        ),
      );
      bloc.add(GroupCreatorEventGroupNameChanged(groupName: 'groupName'));
      bloc.add(GroupCreatorEventSubmit());
    },
    expect: () => [
      GroupCreatorState(
        mode: GroupCreatorEditMode(group: groupsState.allGroups[0]),
        selectedCourse: coursesState.allCourses[0],
        allCourses: coursesState.allCourses,
        groupName: groupsState.allGroups[0].name,
        nameForQuestions: groupsState.allGroups[0].nameForQuestions,
        nameForAnswers: groupsState.allGroups[0].nameForAnswers,
      ),
      GroupCreatorState(
        mode: GroupCreatorEditMode(group: groupsState.allGroups[0]),
        selectedCourse: coursesState.allCourses[0],
        allCourses: coursesState.allCourses,
        groupName: 'groupName',
        nameForQuestions: groupsState.allGroups[0].nameForQuestions,
        nameForAnswers: groupsState.allGroups[0].nameForAnswers,
      ),
    ],
    verify: (_) {
      verify(
        () => groupsBloc.add(
          GroupsEventUpdateGroup(
            groupId: groupsState.allGroups[0].id,
            name: 'groupName',
            courseId: groupsState.allGroups[0].courseId,
            nameForQuestions: groupsState.allGroups[0].nameForQuestions,
            nameForAnswers: groupsState.allGroups[0].nameForAnswers,
          ),
        ),
      ).called(1);
    },
  );
}
