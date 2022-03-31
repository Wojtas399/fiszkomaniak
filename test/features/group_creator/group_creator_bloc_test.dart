import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_event.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_bloc.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_event.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_mode.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_state.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoursesBloc extends Mock implements CoursesBloc {}

class MockGroupsBloc extends Mock implements GroupsBloc {}

void main() {
  final CoursesBloc coursesBloc = MockCoursesBloc();
  final GroupsBloc groupsBloc = MockGroupsBloc();
  late GroupCreatorBloc bloc;
  final List<Course> allCourses = [
    createCourse(id: 'c1'),
    createCourse(id: 'c2'),
    createCourse(id: 'c3'),
  ];

  setUp(() {
    bloc = GroupCreatorBloc(
      coursesBloc: coursesBloc,
      groupsBloc: groupsBloc,
    );
  });

  tearDown(() {
    reset(coursesBloc);
    reset(groupsBloc);
  });

  blocTest(
    'initialize, create mode',
    build: () => bloc,
    setUp: () {
      when(() => coursesBloc.state).thenReturn(
        CoursesState(allCourses: allCourses),
      );
    },
    act: (_) => bloc.add(
      GroupCreatorEventInitialize(mode: const GroupCreatorCreateMode()),
    ),
    expect: () => [
      GroupCreatorState(
        mode: const GroupCreatorCreateMode(),
        selectedCourse: allCourses[0],
        allCourses: allCourses,
      ),
    ],
  );

  blocTest(
    'initialize, edit mode',
    build: () => bloc,
    setUp: () {
      when(() => coursesBloc.state).thenReturn(
        CoursesState(allCourses: allCourses),
      );
    },
    act: (_) => bloc.add(
      GroupCreatorEventInitialize(
        mode: GroupCreatorEditMode(
          group: createGroup(
            id: 'g1',
            courseId: 'c2',
            name: 'name',
            nameForQuestions: 'nameForQuestions',
            nameForAnswers: 'nameForAnswers',
          ),
        ),
      ),
    ),
    expect: () => [
      GroupCreatorState(
        mode: GroupCreatorEditMode(
          group: createGroup(
            id: 'g1',
            courseId: 'c2',
            name: 'name',
            nameForQuestions: 'nameForQuestions',
            nameForAnswers: 'nameForAnswers',
          ),
        ),
        selectedCourse: createCourse(id: 'c2'),
        allCourses: allCourses,
        groupName: 'name',
        nameForQuestions: 'nameForQuestions',
        nameForAnswers: 'nameForAnswers',
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
    setUp: () {
      when(() => coursesBloc.state).thenReturn(
        CoursesState(allCourses: allCourses),
      );
    },
    act: (_) {
      bloc.add(
        GroupCreatorEventInitialize(
          mode: GroupCreatorEditMode(
            group: createGroup(
              id: 'g1',
              courseId: 'c1',
              name: 'name',
              nameForQuestions: 'nameForQuestions',
              nameForAnswers: 'nameForAnswers',
            ),
          ),
        ),
      );
      bloc.add(GroupCreatorEventGroupNameChanged(groupName: 'groupName'));
      bloc.add(GroupCreatorEventSubmit());
    },
    expect: () => [
      GroupCreatorState(
        mode: GroupCreatorEditMode(
          group: createGroup(
            id: 'g1',
            courseId: 'c1',
            name: 'name',
            nameForQuestions: 'nameForQuestions',
            nameForAnswers: 'nameForAnswers',
          ),
        ),
        selectedCourse: createCourse(id: 'c1'),
        allCourses: allCourses,
        groupName: 'name',
        nameForQuestions: 'nameForQuestions',
        nameForAnswers: 'nameForAnswers',
      ),
      GroupCreatorState(
        mode: GroupCreatorEditMode(
          group: createGroup(
            id: 'g1',
            courseId: 'c1',
            name: 'name',
            nameForQuestions: 'nameForQuestions',
            nameForAnswers: 'nameForAnswers',
          ),
        ),
        selectedCourse: createCourse(id: 'c1'),
        allCourses: allCourses,
        groupName: 'groupName',
        nameForQuestions: 'nameForQuestions',
        nameForAnswers: 'nameForAnswers',
      ),
    ],
    verify: (_) {
      verify(
        () => groupsBloc.add(
          GroupsEventUpdateGroup(
            groupId: 'g1',
            name: 'groupName',
            courseId: 'c1',
            nameForQuestions: 'nameForQuestions',
            nameForAnswers: 'nameForAnswers',
          ),
        ),
      ).called(1);
    },
  );
}
