import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/load_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_groups_by_course_id_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/add_session_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/update_session_use_case.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_bloc.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_mode.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/time_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadAllCoursesUseCase extends Mock implements LoadAllCoursesUseCase {}

class MockGetAllCoursesUseCase extends Mock implements GetAllCoursesUseCase {}

class MockGetCourseUseCase extends Mock implements GetCourseUseCase {}

class MockGetGroupUseCase extends Mock implements GetGroupUseCase {}

class MockGetGroupsByCourseIdUseCase extends Mock
    implements GetGroupsByCourseIdUseCase {}

class MockAddSessionUseCase extends Mock implements AddSessionUseCase {}

class MockUpdateSessionUseCase extends Mock implements UpdateSessionUseCase {}

void main() {
  final loadAllCoursesUseCase = MockLoadAllCoursesUseCase();
  final getAllCoursesUseCase = MockGetAllCoursesUseCase();
  final getCourseUseCase = MockGetCourseUseCase();
  final getGroupUseCase = MockGetGroupUseCase();
  final getGroupsByCourseIdUseCase = MockGetGroupsByCourseIdUseCase();
  final addSessionUseCase = MockAddSessionUseCase();
  final updateSessionUseCase = MockUpdateSessionUseCase();

  SessionCreatorBloc createBloc({
    BlocStatus status = const BlocStatusInitial(),
    SessionCreatorMode mode = const SessionCreatorCreateMode(),
    List<Course> courses = const [],
    List<Group>? groups,
    Course? selectedCourse,
    Group? selectedGroup,
    FlashcardsType flashcardsType = FlashcardsType.all,
    bool areQuestionsAndAnswersSwapped = false,
    Date? date,
    Time? startTime,
    Duration? duration,
    Time? notificationTime,
  }) {
    return SessionCreatorBloc(
      loadAllCoursesUseCase: loadAllCoursesUseCase,
      getAllCoursesUseCase: getAllCoursesUseCase,
      getCourseUseCase: getCourseUseCase,
      getGroupUseCase: getGroupUseCase,
      getGroupsByCourseIdUseCase: getGroupsByCourseIdUseCase,
      addSessionUseCase: addSessionUseCase,
      updateSessionUseCase: updateSessionUseCase,
      status: status,
      mode: mode,
      courses: courses,
      groups: groups,
      selectedCourse: selectedCourse,
      selectedGroup: selectedGroup,
      flashcardsType: flashcardsType,
      areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
      date: date,
      startTime: startTime,
      duration: duration,
      notificationTime: notificationTime,
    );
  }

  SessionCreatorState createState({
    BlocStatus status = const BlocStatusComplete<SessionCreatorInfoType>(),
    SessionCreatorMode mode = const SessionCreatorCreateMode(),
    List<Course> courses = const [],
    List<Group>? groups,
    Course? selectedCourse,
    Group? selectedGroup,
    FlashcardsType flashcardsType = FlashcardsType.all,
    bool areQuestionsAndAnswersSwapped = false,
    Date? date,
    Time? startTime,
    Duration? duration,
    Time? notificationTime,
  }) {
    return SessionCreatorState(
      status: status,
      mode: mode,
      courses: courses,
      groups: groups,
      selectedCourse: selectedCourse,
      selectedGroup: selectedGroup,
      flashcardsType: flashcardsType,
      areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
      date: date,
      startTime: startTime,
      duration: duration,
      notificationTime: notificationTime,
    );
  }

  tearDown(() {
    reset(loadAllCoursesUseCase);
    reset(getAllCoursesUseCase);
    reset(getCourseUseCase);
    reset(getGroupUseCase);
    reset(getGroupsByCourseIdUseCase);
    reset(addSessionUseCase);
    reset(updateSessionUseCase);
  });

  group(
    'initialize',
    () {
      final List<Course> allCourses = [
        createCourse(id: 'c1', name: 'course 1'),
        createCourse(id: 'c2', name: 'course 2'),
      ];
      final List<Group> groups = [
        createGroup(id: 'g1', courseId: 'c1'),
        createGroup(id: 'g2', courseId: 'c2'),
      ];
      final Session session = createSession(
        id: 's1',
        groupId: 'g1',
        flashcardsType: FlashcardsType.notRemembered,
        areQuestionsAndAnswersSwapped: true,
        date: const Date(year: 2022, month: 2, day: 2),
        startTime: const Time(hour: 12, minute: 30),
      );

      setUp(() {
        when(
          () => loadAllCoursesUseCase.execute(),
        ).thenAnswer((_) async => '');
        when(
          () => getAllCoursesUseCase.execute(),
        ).thenAnswer((_) => Stream.value(allCourses));
      });

      blocTest(
        'create mode, should load and set all courses in state',
        build: () => createBloc(),
        act: (SessionCreatorBloc bloc) {
          bloc.add(
            SessionCreatorEventInitialize(
              mode: const SessionCreatorCreateMode(),
            ),
          );
        },
        expect: () => [
          createState(status: const BlocStatusLoading()),
          createState(courses: allCourses),
        ],
        verify: (_) {
          verify(() => loadAllCoursesUseCase.execute()).called(1);
          verify(() => getAllCoursesUseCase.execute()).called(1);
        },
      );

      blocTest(
        'edit mode, should load and set all courses, groups from course and group and course assigned to session',
        build: () => createBloc(),
        setUp: () {
          when(
            () => getGroupUseCase.execute(groupId: 'g1'),
          ).thenAnswer((_) => Stream.value(groups[0]));
          when(
            () => getCourseUseCase.execute(courseId: 'c1'),
          ).thenAnswer((_) => Stream.value(allCourses[0]));
          when(
            () => getGroupsByCourseIdUseCase.execute(courseId: 'c1'),
          ).thenAnswer((_) => Stream.value(groups));
        },
        act: (SessionCreatorBloc bloc) {
          bloc.add(
            SessionCreatorEventInitialize(
              mode: SessionCreatorEditMode(session: session),
            ),
          );
        },
        expect: () => [
          createState(status: const BlocStatusLoading()),
          createState(
            mode: SessionCreatorEditMode(session: session),
            courses: allCourses,
            groups: groups,
            selectedCourse: allCourses[0],
            selectedGroup: groups[0],
            flashcardsType: session.flashcardsType,
            areQuestionsAndAnswersSwapped:
                session.areQuestionsAndAnswersSwapped,
            date: session.date,
            startTime: session.startTime,
            duration: session.duration,
            notificationTime: session.notificationTime,
          ),
        ],
        verify: (_) {
          verify(() => loadAllCoursesUseCase.execute()).called(1);
          verify(() => getAllCoursesUseCase.execute()).called(1);
          verify(() => getGroupUseCase.execute(groupId: 'g1')).called(1);
          verify(() => getCourseUseCase.execute(courseId: 'c1')).called(1);
          verify(
            () => getGroupsByCourseIdUseCase.execute(courseId: 'c1'),
          ).called(1);
        },
      );
    },
  );

  group(
    'course selected',
    () {
      final Course selectedCourse = createCourse(id: 'c1', name: 'course 1');
      final List<Group> groupsFromCourse = [
        createGroup(
          id: 'g1',
          courseId: 'c1',
          flashcards: [
            createFlashcard(index: 0, question: 'q0', answer: 'a0'),
          ],
        ),
        createGroup(id: 'g2', courseId: 'c2'),
      ];

      setUp(() {
        when(
          () => getCourseUseCase.execute(courseId: 'c1'),
        ).thenAnswer((_) => Stream.value(selectedCourse));
        when(
          () => getGroupsByCourseIdUseCase.execute(courseId: 'c1'),
        ).thenAnswer((_) => Stream.value(groupsFromCourse));
      });

      blocTest(
        'should update in state selected course and groups from this course which have at least one flashcard',
        build: () => createBloc(
          selectedCourse: selectedCourse,
          selectedGroup: groupsFromCourse[0],
        ),
        act: (SessionCreatorBloc bloc) {
          bloc.add(SessionCreatorEventCourseSelected(courseId: 'c1'));
        },
        expect: () => [
          createState(
            groups: [groupsFromCourse[0]],
            selectedCourse: selectedCourse,
            selectedGroup: groupsFromCourse[0],
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
        'should set selected group as null if selected course is different than currently set one',
        build: () => createBloc(
          selectedCourse: createCourse(id: 'c2'),
          selectedGroup: groupsFromCourse[0],
        ),
        act: (SessionCreatorBloc bloc) {
          bloc.add(SessionCreatorEventCourseSelected(courseId: 'c1'));
        },
        expect: () => [
          createState(
            selectedCourse: createCourse(id: 'c2'),
            selectedGroup: null,
          ),
          createState(
            groups: [groupsFromCourse[0]],
            selectedCourse: selectedCourse,
            selectedGroup: null,
          ),
        ],
        verify: (_) {
          verify(() => getCourseUseCase.execute(courseId: 'c1')).called(1);
          verify(
            () => getGroupsByCourseIdUseCase.execute(courseId: 'c1'),
          ).called(1);
        },
      );
    },
  );

  group(
    'group selected',
    () {
      final Group selectedGroup = createGroup(id: 'g1', name: 'group 1');

      blocTest(
        'should load and update selected group in state',
        build: () => createBloc(),
        setUp: () {
          when(
            () => getGroupUseCase.execute(groupId: 'g1'),
          ).thenAnswer((_) => Stream.value(selectedGroup));
        },
        act: (SessionCreatorBloc bloc) {
          bloc.add(SessionCreatorEventGroupSelected(groupId: 'g1'));
        },
        expect: () => [
          createState(selectedGroup: selectedGroup),
        ],
      );
    },
  );

  blocTest(
    'flashcards type selected, should update selected flashcards type in state',
    build: () => createBloc(),
    act: (SessionCreatorBloc bloc) {
      bloc.add(
        SessionCreatorEventFlashcardsTypeSelected(
          type: FlashcardsType.remembered,
        ),
      );
    },
    expect: () => [
      createState(flashcardsType: FlashcardsType.remembered),
    ],
  );

  blocTest(
    'swap questions name with answers name, should set negation of current value if group has been selected',
    build: () => createBloc(
      selectedGroup: createGroup(id: 'g1'),
      areQuestionsAndAnswersSwapped: false,
    ),
    act: (SessionCreatorBloc bloc) {
      bloc.add(SessionCreatorEventSwapQuestionsWithAnswers());
    },
    expect: () => [
      createState(
        selectedGroup: createGroup(id: 'g1'),
        areQuestionsAndAnswersSwapped: true,
      ),
    ],
  );

  blocTest(
    'swap questions name with answers name, should not change value if group has not been selected',
    build: () => createBloc(areQuestionsAndAnswersSwapped: false),
    act: (SessionCreatorBloc bloc) {
      bloc.add(SessionCreatorEventSwapQuestionsWithAnswers());
    },
    expect: () => [],
  );

  blocTest(
    'date selected, should emit appropriate info if date with start time is from the past',
    build: () => createBloc(
      startTime: const Time(hour: 12, minute: 30),
    ),
    act: (SessionCreatorBloc bloc) {
      bloc.add(
        SessionCreatorEventDateSelected(
          date: const Date(year: 2022, month: 1, day: 1),
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete<SessionCreatorInfoType>(
          info: SessionCreatorInfoType.timeFromThePast,
        ),
        startTime: const Time(hour: 12, minute: 30),
      ),
    ],
  );

  blocTest(
    'date selected, should emit appropriate info if date with notification time is from the past',
    build: () => createBloc(
      notificationTime: const Time(hour: 12, minute: 30),
    ),
    act: (SessionCreatorBloc bloc) {
      bloc.add(
        SessionCreatorEventDateSelected(
          date: const Date(year: 2022, month: 1, day: 1),
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete<SessionCreatorInfoType>(
          info: SessionCreatorInfoType.timeFromThePast,
        ),
        notificationTime: const Time(hour: 12, minute: 30),
      ),
    ],
  );

  blocTest(
    'date selected, should update date in state if it is not from the past',
    build: () => createBloc(),
    act: (SessionCreatorBloc bloc) {
      bloc.add(
        SessionCreatorEventDateSelected(
          date: const Date(year: 2022, month: 1, day: 1),
        ),
      );
    },
    expect: () => [
      createState(
        date: const Date(year: 2022, month: 1, day: 1),
      ),
    ],
  );

  blocTest(
    'start time selected, should emit appropriate info if chosen start time is from the past',
    build: () => createBloc(
      date: const Date(year: 2022, month: 1, day: 1),
    ),
    act: (SessionCreatorBloc bloc) {
      bloc.add(
        SessionCreatorEventStartTimeSelected(
          startTime: const Time(hour: 12, minute: 30),
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete<SessionCreatorInfoType>(
          info: SessionCreatorInfoType.timeFromThePast,
        ),
        date: const Date(year: 2022, month: 1, day: 1),
      ),
    ],
  );

  blocTest(
    'start time selected, should emit appropriate info if chosen start time is earlier than notification time',
    build: () => createBloc(
      notificationTime: const Time(hour: 19, minute: 45),
    ),
    act: (SessionCreatorBloc bloc) {
      bloc.add(
        SessionCreatorEventStartTimeSelected(
          startTime: const Time(hour: 12, minute: 10),
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete<SessionCreatorInfoType>(
          info: SessionCreatorInfoType
              .chosenStartTimeIsEarlierThanNotificationTime,
        ),
        notificationTime: const Time(hour: 19, minute: 45),
      ),
    ],
  );

  blocTest(
    'start time selected, should update start time in state if it is correct',
    build: () => createBloc(),
    act: (SessionCreatorBloc bloc) {
      bloc.add(
        SessionCreatorEventStartTimeSelected(
          startTime: const Time(hour: 13, minute: 30),
        ),
      );
    },
    expect: () => [
      createState(
        startTime: const Time(hour: 13, minute: 30),
      ),
    ],
  );

  blocTest(
    'duration selected, should update duration in state',
    build: () => createBloc(),
    act: (SessionCreatorBloc bloc) {
      bloc.add(
        SessionCreatorEventDurationSelected(
          duration: const Duration(minutes: 15),
        ),
      );
    },
    expect: () => [
      createState(
        duration: const Duration(minutes: 15),
      ),
    ],
  );

  blocTest(
    'notification time selected, should emit appropriate info if chosen notification time is from the past',
    build: () => createBloc(
      date: const Date(year: 2022, month: 1, day: 1),
    ),
    act: (SessionCreatorBloc bloc) {
      bloc.add(
        SessionCreatorEventNotificationTimeSelected(
          notificationTime: const Time(hour: 12, minute: 30),
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete<SessionCreatorInfoType>(
          info: SessionCreatorInfoType.timeFromThePast,
        ),
        date: const Date(year: 2022, month: 1, day: 1),
      ),
    ],
  );

  blocTest(
    'notification time selected, should emit appropriate info if chosen notification time is later than start time',
    build: () => createBloc(
      startTime: const Time(hour: 12, minute: 45),
    ),
    act: (SessionCreatorBloc bloc) {
      bloc.add(
        SessionCreatorEventNotificationTimeSelected(
          notificationTime: const Time(hour: 13, minute: 0),
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete<SessionCreatorInfoType>(
          info:
              SessionCreatorInfoType.chosenNotificationTimeIsLaterThanStartTime,
        ),
        startTime: const Time(hour: 12, minute: 45),
      ),
    ],
  );

  blocTest(
    'notification time selected, should update notification time in state if it is correct',
    build: () => createBloc(),
    act: (SessionCreatorBloc bloc) {
      bloc.add(
        SessionCreatorEventNotificationTimeSelected(
          notificationTime: const Time(hour: 13, minute: 30),
        ),
      );
    },
    expect: () => [
      createState(
        notificationTime: const Time(hour: 13, minute: 30),
      ),
    ],
  );

  blocTest(
    'clean duration time, should set duration time as null in state',
    build: () => createBloc(
      duration: const Duration(minutes: 15),
    ),
    act: (SessionCreatorBloc bloc) {
      bloc.add(SessionCreatorEventCleanDurationTime());
    },
    expect: () => [
      createState(duration: null),
    ],
  );

  blocTest(
    'clean notification time, should set notification time as null in state',
    build: () => createBloc(
      notificationTime: const Time(hour: 12, minute: 30),
    ),
    act: (SessionCreatorBloc bloc) {
      bloc.add(SessionCreatorEventCleanNotificationTime());
    },
    expect: () => [
      createState(notificationTime: null),
    ],
  );

  group(
    'submit',
    () {
      final Session session = createSession(
        id: 's1',
        groupId: 'g1',
        flashcardsType: FlashcardsType.remembered,
        areQuestionsAndAnswersSwapped: true,
        date: const Date(year: 2022, month: 5, day: 5),
        startTime: const Time(hour: 15, minute: 30),
        duration: const Duration(minutes: 30),
        notificationTime: const Time(hour: 10, minute: 30),
      );

      blocTest(
        'create mode, should call use case responsible for adding new session',
        build: () => createBloc(
          selectedGroup: createGroup(id: 'g1'),
          flashcardsType: session.flashcardsType,
          areQuestionsAndAnswersSwapped: true,
          date: session.date,
          startTime: session.startTime,
          duration: session.duration,
          notificationTime: session.notificationTime,
        ),
        setUp: () {
          when(
            () => addSessionUseCase.execute(
              groupId: session.groupId,
              flashcardsType: session.flashcardsType,
              areQuestionsAndAnswersSwapped: true,
              date: session.date,
              startTime: session.startTime,
              duration: session.duration,
              notificationTime: session.notificationTime,
            ),
          ).thenAnswer((_) async => '');
        },
        act: (SessionCreatorBloc bloc) {
          bloc.add(SessionCreatorEventSubmit());
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            selectedGroup: createGroup(id: 'g1'),
            flashcardsType: session.flashcardsType,
            areQuestionsAndAnswersSwapped: true,
            date: session.date,
            startTime: session.startTime,
            duration: session.duration,
            notificationTime: session.notificationTime,
          ),
          createState(
            status: const BlocStatusComplete<SessionCreatorInfoType>(
              info: SessionCreatorInfoType.sessionHasBeenAdded,
            ),
            selectedGroup: createGroup(id: 'g1'),
            flashcardsType: session.flashcardsType,
            areQuestionsAndAnswersSwapped: true,
            date: session.date,
            startTime: session.startTime,
            duration: session.duration,
            notificationTime: session.notificationTime,
          ),
        ],
        verify: (_) {
          verify(
            () => addSessionUseCase.execute(
              groupId: session.groupId,
              flashcardsType: session.flashcardsType,
              areQuestionsAndAnswersSwapped: true,
              date: session.date,
              startTime: session.startTime,
              duration: session.duration,
              notificationTime: session.notificationTime,
            ),
          ).called(1);
        },
      );

      blocTest(
        'edit mode, should call use case responsible for updating new session',
        build: () => createBloc(
          mode: SessionCreatorEditMode(session: session),
          selectedGroup: createGroup(id: 'g1'),
          flashcardsType: session.flashcardsType,
          areQuestionsAndAnswersSwapped: true,
          date: session.date,
          startTime: session.startTime,
          duration: session.duration,
          notificationTime: session.notificationTime,
        ),
        setUp: () {
          when(
            () => updateSessionUseCase.execute(
              sessionId: session.id,
              groupId: session.groupId,
              flashcardsType: session.flashcardsType,
              areQuestionsAndAnswersSwapped: true,
              date: session.date,
              startTime: session.startTime,
              duration: session.duration,
              notificationTime: session.notificationTime,
            ),
          ).thenAnswer((_) async => '');
        },
        act: (SessionCreatorBloc bloc) {
          bloc.add(SessionCreatorEventSubmit());
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            mode: SessionCreatorEditMode(session: session),
            selectedGroup: createGroup(id: 'g1'),
            flashcardsType: session.flashcardsType,
            areQuestionsAndAnswersSwapped: true,
            date: session.date,
            startTime: session.startTime,
            duration: session.duration,
            notificationTime: session.notificationTime,
          ),
          createState(
            status: const BlocStatusComplete<SessionCreatorInfoType>(
              info: SessionCreatorInfoType.sessionHasBeenUpdated,
            ),
            mode: SessionCreatorEditMode(session: session),
            selectedGroup: createGroup(id: 'g1'),
            flashcardsType: session.flashcardsType,
            areQuestionsAndAnswersSwapped: true,
            date: session.date,
            startTime: session.startTime,
            duration: session.duration,
            notificationTime: session.notificationTime,
          ),
        ],
        verify: (_) {
          verify(
            () => updateSessionUseCase.execute(
              sessionId: session.id,
              groupId: session.groupId,
              flashcardsType: session.flashcardsType,
              areQuestionsAndAnswersSwapped: true,
              date: session.date,
              startTime: session.startTime,
              duration: session.duration,
              notificationTime: session.notificationTime,
            ),
          ).called(1);
        },
      );
    },
  );
}
