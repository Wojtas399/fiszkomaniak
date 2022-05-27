import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_bloc.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_status.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_event.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_mode.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_state.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:fiszkomaniak/models/time_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoursesBloc extends Mock implements CoursesBloc {}

class MockGroupsBloc extends Mock implements GroupsBloc {}

class MockSessionsBloc extends Mock implements SessionsBloc {}

class FakeSessionsEvent extends Fake implements SessionsEvent {}

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay subtractMinutes(int minutes) {
    return replacing(hour: hour, minute: minute - minutes);
  }
}

void main() {
  final CoursesBloc coursesBloc = MockCoursesBloc();
  final GroupsBloc groupsBloc = MockGroupsBloc();
  final SessionsBloc sessionsBloc = MockSessionsBloc();
  late SessionCreatorBloc bloc;
  final Date now = Date.now();
  final CoursesState coursesState = CoursesState(
    allCourses: [
      createCourse(id: 'c1'),
      createCourse(id: 'c2'),
    ],
  );
  final GroupsState groupsState = GroupsState(
    allGroups: [
      createGroup(id: 'g1', courseId: 'c1', flashcards: [createFlashcard()]),
      createGroup(id: 'g2', courseId: 'c1', flashcards: [createFlashcard()]),
      createGroup(id: 'g3', courseId: 'c2', flashcards: [createFlashcard()]),
      createGroup(id: 'g4', courseId: 'c1'),
    ],
  );
  final Session session = createSession(
    id: 's1',
    groupId: 'g1',
    flashcardsType: FlashcardsType.remembered,
    areQuestionsAndAnswersSwapped: true,
    date: const Date(year: 2022, month: 1, day: 1),
    time: const Time(hour: 20, minute: 00),
    duration: const Duration(minutes: 30),
    notificationTime: const Time(hour: 10, minute: 0),
    notificationStatus: NotificationStatus.incoming,
  );
  final SessionCreatorState initialEditModeState = SessionCreatorState(
    mode: SessionCreatorEditMode(session: session),
    status: SessionCreatorStatusLoaded(),
    courses: coursesState.allCourses,
    groups: [
      groupsState.allGroups[0],
      groupsState.allGroups[1],
      groupsState.allGroups[3],
    ],
    selectedCourse: coursesState.allCourses[0],
    selectedGroup: groupsState.allGroups[0],
    flashcardsType: session.flashcardsType,
    areQuestionsAndAnswersSwapped: session.areQuestionsAndAnswersSwapped,
    date: session.date,
    time: session.time,
    duration: session.duration,
    notificationTime: session.notificationTime,
  );

  setUp(() {
    bloc = SessionCreatorBloc(
      coursesBloc: coursesBloc,
      groupsBloc: groupsBloc,
      sessionsBloc: sessionsBloc,
    );
    when(() => coursesBloc.state).thenReturn(coursesState);
    when(() => groupsBloc.state).thenReturn(groupsState);
  });

  tearDown(() {
    reset(coursesBloc);
    reset(groupsBloc);
    reset(sessionsBloc);
  });

  blocTest(
    'initialize create mode',
    build: () => bloc,
    act: (_) => bloc.add(
      SessionCreatorEventInitialize(mode: const SessionCreatorCreateMode()),
    ),
    expect: () => [
      SessionCreatorState(
        status: SessionCreatorStatusLoaded(),
        courses: coursesState.allCourses,
      ),
    ],
  );

  blocTest(
    'initialize edit mode',
    build: () => bloc,
    act: (_) => bloc.add(
      SessionCreatorEventInitialize(
        mode: SessionCreatorEditMode(session: session),
      ),
    ),
    expect: () => [initialEditModeState],
  );

  blocTest(
    'course selected, different than current',
    build: () => bloc,
    act: (_) {
      bloc.add(SessionCreatorEventCourseSelected(courseId: 'c2'));
      bloc.add(SessionCreatorEventGroupSelected(groupId: 'g2'));
      bloc.add(SessionCreatorEventCourseSelected(courseId: 'c1'));
    },
    expect: () => [
      SessionCreatorState(
        status: SessionCreatorStatusLoaded(),
        selectedCourse: coursesState.allCourses[1],
        groups: [
          groupsState.allGroups[2],
        ],
      ),
      SessionCreatorState(
        status: SessionCreatorStatusLoaded(),
        selectedCourse: coursesState.allCourses[1],
        selectedGroup: groupsState.allGroups[1],
        groups: [
          groupsState.allGroups[2],
        ],
      ),
      SessionCreatorState(
        status: SessionCreatorStatusLoaded(),
        selectedCourse: coursesState.allCourses[1],
        selectedGroup: null,
        groups: [
          groupsState.allGroups[2],
        ],
      ),
      SessionCreatorState(
        status: SessionCreatorStatusLoaded(),
        selectedCourse: coursesState.allCourses[0],
        selectedGroup: null,
        groups: [
          groupsState.allGroups[0],
          groupsState.allGroups[1],
        ],
      ),
    ],
  );

  blocTest(
    'course selected, the same',
    build: () => bloc,
    act: (_) {
      bloc.add(SessionCreatorEventCourseSelected(courseId: 'c1'));
      bloc.add(SessionCreatorEventGroupSelected(groupId: 'g2'));
      bloc.add(SessionCreatorEventCourseSelected(courseId: 'c1'));
    },
    expect: () => [
      SessionCreatorState(
        status: SessionCreatorStatusLoaded(),
        selectedCourse: coursesState.allCourses[0],
        groups: [
          groupsState.allGroups[0],
          groupsState.allGroups[1],
        ],
      ),
      SessionCreatorState(
        status: SessionCreatorStatusLoaded(),
        selectedCourse: coursesState.allCourses[0],
        selectedGroup: groupsState.allGroups[1],
        groups: [
          groupsState.allGroups[0],
          groupsState.allGroups[1],
        ],
      ),
    ],
  );

  blocTest(
    'course selected, does not exist in core',
    build: () => bloc,
    act: (_) => bloc.add(SessionCreatorEventCourseSelected(courseId: 's3')),
    expect: () => [],
  );

  blocTest(
    'group selected',
    build: () => bloc,
    act: (_) => bloc.add(SessionCreatorEventGroupSelected(groupId: 'g1')),
    expect: () => [
      SessionCreatorState(
        status: SessionCreatorStatusLoaded(),
        selectedGroup: groupsState.allGroups[0],
      ),
    ],
  );

  blocTest(
    'group selected, does not exist in core',
    build: () => bloc,
    act: (_) => bloc.add(SessionCreatorEventGroupSelected(groupId: 'g5')),
    expect: () => [],
  );

  blocTest(
    'flashcards type selected',
    build: () => bloc,
    act: (_) => bloc.add(SessionCreatorEventFlashcardsTypeSelected(
      type: FlashcardsType.remembered,
    )),
    expect: () => [
      SessionCreatorState(
        status: SessionCreatorStatusLoaded(),
        flashcardsType: FlashcardsType.remembered,
      ),
    ],
  );

  blocTest(
    'swap questions with answer, group not selected',
    build: () => bloc,
    act: (_) => bloc.add(SessionCreatorEventSwapQuestionsWithAnswers()),
    expect: () => [],
  );

  blocTest(
    'swap questions with answer, group selected',
    build: () => bloc,
    act: (_) {
      bloc.add(SessionCreatorEventGroupSelected(groupId: 'g1'));
      bloc.add(SessionCreatorEventSwapQuestionsWithAnswers());
    },
    expect: () => [
      SessionCreatorState(
        status: SessionCreatorStatusLoaded(),
        selectedGroup: groupsState.allGroups[0],
      ),
      SessionCreatorState(
        status: SessionCreatorStatusLoaded(),
        selectedGroup: groupsState.allGroups[0],
        areQuestionsAndAnswersSwapped: true,
      ),
    ],
  );

  blocTest(
    'date selected',
    build: () => bloc,
    act: (_) => bloc.add(SessionCreatorEventDateSelected(date: createDate())),
    expect: () => [
      SessionCreatorState(
        status: SessionCreatorStatusLoaded(),
        date: createDate(),
      ),
    ],
  );

  blocTest(
    'time selected, time from the past',
    build: () => bloc,
    act: (_) {
      bloc.add(
        SessionCreatorEventInitialize(
          mode: SessionCreatorEditMode(session: session),
        ),
      );
      bloc.add(
        SessionCreatorEventTimeSelected(
          time: const Time(hour: 12, minute: 0),
        ),
      );
    },
    expect: () => [
      initialEditModeState,
      initialEditModeState.copyWith(
        status: SessionCreatorStatusTimeFromThePast(),
      ),
    ],
  );

  blocTest(
    'time selected, earlier than notification time',
    build: () => bloc,
    act: (_) {
      bloc.add(
        SessionCreatorEventInitialize(
          mode: SessionCreatorEditMode(
            session: session.copyWith(date: now.addDays(2)),
          ),
        ),
      );
      bloc.add(
        SessionCreatorEventTimeSelected(time: const Time(hour: 9, minute: 0)),
      );
    },
    expect: () => [
      initialEditModeState.copyWith(
        mode: SessionCreatorEditMode(
          session: session.copyWith(date: now.addDays(2)),
        ),
        date: now.addDays(2),
      ),
      initialEditModeState.copyWith(
        mode: SessionCreatorEditMode(
          session: session.copyWith(date: now.addDays(2)),
        ),
        status: SessionCreatorStatusStartTimeEarlierThanNotificationTime(),
        date: now.addDays(2),
      ),
    ],
  );

  blocTest(
    'time selected, correct time',
    build: () => bloc,
    act: (_) {
      bloc.add(
        SessionCreatorEventInitialize(
          mode: SessionCreatorEditMode(
            session: session.copyWith(date: now.addDays(2)),
          ),
        ),
      );
      bloc.add(
        SessionCreatorEventTimeSelected(time: const Time(hour: 12, minute: 0)),
      );
    },
    expect: () => [
      initialEditModeState.copyWith(
        mode: SessionCreatorEditMode(
          session: session.copyWith(date: now.addDays(2)),
        ),
        date: now.addDays(2),
      ),
      initialEditModeState.copyWith(
        mode: SessionCreatorEditMode(
          session: session.copyWith(date: now.addDays(2)),
        ),
        date: now.addDays(2),
        time: const Time(hour: 12, minute: 0),
      ),
    ],
  );

  blocTest(
    'duration selected',
    build: () => bloc,
    act: (_) => bloc.add(
      SessionCreatorEventDurationSelected(
        duration: const Duration(minutes: 15),
      ),
    ),
    expect: () => [
      SessionCreatorState(
        status: SessionCreatorStatusLoaded(),
        duration: const Duration(minutes: 15),
      )
    ],
  );

  blocTest(
    'notification time selected, time from the past',
    build: () => bloc,
    act: (_) {
      bloc.add(
        SessionCreatorEventInitialize(
          mode: SessionCreatorEditMode(session: session),
        ),
      );
      bloc.add(
        SessionCreatorEventNotificationTimeSelected(
          notificationTime: const Time(hour: 12, minute: 0),
        ),
      );
    },
    expect: () => [
      initialEditModeState,
      initialEditModeState.copyWith(
        status: SessionCreatorStatusTimeFromThePast(),
      ),
    ],
  );

  blocTest(
    'notification time selected, later than start time',
    build: () => bloc,
    act: (_) {
      bloc.add(
        SessionCreatorEventInitialize(
          mode: SessionCreatorEditMode(
            session: session.copyWith(date: now.addDays(2)),
          ),
        ),
      );
      bloc.add(
        SessionCreatorEventNotificationTimeSelected(
          notificationTime: const Time(hour: 21, minute: 0),
        ),
      );
    },
    expect: () => [
      initialEditModeState.copyWith(
        mode: SessionCreatorEditMode(
          session: session.copyWith(date: now.addDays(2)),
        ),
        date: now.addDays(2),
      ),
      initialEditModeState.copyWith(
        mode: SessionCreatorEditMode(
          session: session.copyWith(date: now.addDays(2)),
        ),
        status: SessionCreatorStatusNotificationTimeLaterThanStartTime(),
        date: now.addDays(2),
      ),
    ],
  );

  blocTest(
    'notification time selected, correct time',
    build: () => bloc,
    act: (_) {
      bloc.add(
        SessionCreatorEventInitialize(
          mode: SessionCreatorEditMode(
            session: session.copyWith(date: now.addDays(2)),
          ),
        ),
      );
      bloc.add(
        SessionCreatorEventNotificationTimeSelected(
          notificationTime: const Time(hour: 12, minute: 0),
        ),
      );
    },
    expect: () => [
      initialEditModeState.copyWith(
        mode: SessionCreatorEditMode(
          session: session.copyWith(date: now.addDays(2)),
        ),
        date: now.addDays(2),
      ),
      initialEditModeState.copyWith(
        mode: SessionCreatorEditMode(
          session: session.copyWith(date: now.addDays(2)),
        ),
        date: now.addDays(2),
        notificationTime: const Time(hour: 12, minute: 0),
      ),
    ],
  );

  blocTest(
    'clean duration',
    build: () => bloc,
    act: (_) {
      bloc.add(SessionCreatorEventDurationSelected(
        duration: const Duration(minutes: 30),
      ));
      bloc.add(SessionCreatorEventCleanDurationTime());
    },
    expect: () => [
      SessionCreatorState(
        status: SessionCreatorStatusLoaded(),
        duration: const Duration(minutes: 30),
      ),
      SessionCreatorState(
        status: SessionCreatorStatusLoaded(),
        duration: null,
      ),
    ],
  );

  blocTest(
    'clean notification time',
    build: () => bloc,
    act: (_) {
      bloc.add(SessionCreatorEventNotificationTimeSelected(
        notificationTime: const Time(hour: 12, minute: 30),
      ));
      bloc.add(SessionCreatorEventCleanNotificationTime());
    },
    expect: () => [
      SessionCreatorState(
        status: SessionCreatorStatusLoaded(),
        notificationTime: const Time(hour: 12, minute: 30),
      ),
      SessionCreatorState(
        status: SessionCreatorStatusLoaded(),
        notificationTime: null,
      ),
    ],
  );

  group('submit, create mode', () {
    final Session session = createSession(
      groupId: 'g1',
      flashcardsType: FlashcardsType.all,
      areQuestionsAndAnswersSwapped: false,
      date: Date.now().addDays(2),
      time: Time.now().addMinutes(30),
      duration: const Duration(minutes: 30),
      notificationTime: Time.now().addMinutes(5),
      notificationStatus: NotificationStatus.incoming,
    );

    setUpAll(() {
      registerFallbackValue(FakeSessionsEvent());
    });

    setUp(() {
      when(
        () => sessionsBloc.add(SessionsEventAddSession(session: session)),
      ).thenAnswer((_) async => '');
    });

    blocTest(
      'all params completed',
      build: () => bloc,
      act: (_) {
        bloc.add(SessionCreatorEventGroupSelected(groupId: session.groupId));
        bloc.add(SessionCreatorEventDateSelected(date: session.date));
        bloc.add(SessionCreatorEventTimeSelected(time: session.time));
        bloc.add(SessionCreatorEventDurationSelected(
          duration: session.duration!,
        ));
        bloc.add(SessionCreatorEventNotificationTimeSelected(
          notificationTime: session.notificationTime!,
        ));
        bloc.add(SessionCreatorEventSubmit());
      },
      verify: (_) {
        verify(
          () => sessionsBloc.add(SessionsEventAddSession(session: session)),
        ).called(1);
      },
    );

    blocTest(
      'group not selected',
      build: () => bloc,
      act: (_) {
        bloc.add(SessionCreatorEventDateSelected(date: session.date));
        bloc.add(SessionCreatorEventTimeSelected(time: session.time));
        bloc.add(SessionCreatorEventDurationSelected(
          duration: session.duration!,
        ));
        bloc.add(SessionCreatorEventNotificationTimeSelected(
          notificationTime: session.notificationTime!,
        ));
        bloc.add(SessionCreatorEventSubmit());
      },
      verify: (_) {
        verifyNever(() => sessionsBloc.add(any()));
      },
    );

    blocTest(
      'date not selected',
      build: () => bloc,
      act: (_) {
        bloc.add(SessionCreatorEventGroupSelected(groupId: session.groupId));
        bloc.add(SessionCreatorEventTimeSelected(time: session.time));
        bloc.add(SessionCreatorEventDurationSelected(
          duration: session.duration!,
        ));
        bloc.add(SessionCreatorEventNotificationTimeSelected(
          notificationTime: session.notificationTime!,
        ));
        bloc.add(SessionCreatorEventSubmit());
      },
      verify: (_) {
        verifyNever(() => sessionsBloc.add(any()));
      },
    );

    blocTest(
      'time not selected',
      build: () => bloc,
      act: (_) {
        bloc.add(SessionCreatorEventGroupSelected(groupId: session.groupId));
        bloc.add(SessionCreatorEventDateSelected(date: session.date));
        bloc.add(SessionCreatorEventDurationSelected(
          duration: session.duration!,
        ));
        bloc.add(SessionCreatorEventNotificationTimeSelected(
          notificationTime: session.notificationTime!,
        ));
        bloc.add(SessionCreatorEventSubmit());
      },
      verify: (_) {
        verifyNever(() => sessionsBloc.add(any()));
      },
    );

    blocTest(
      'duration not selected',
      build: () => bloc,
      act: (_) {
        bloc.add(SessionCreatorEventGroupSelected(groupId: session.groupId));
        bloc.add(SessionCreatorEventDateSelected(date: session.date));
        bloc.add(SessionCreatorEventTimeSelected(time: session.time));
        bloc.add(SessionCreatorEventNotificationTimeSelected(
          notificationTime: session.notificationTime!,
        ));
        bloc.add(SessionCreatorEventSubmit());
      },
      verify: (_) {
        verify(
          () => sessionsBloc.add(
            SessionsEventAddSession(
              session: createSession(
                groupId: session.groupId,
                flashcardsType: session.flashcardsType,
                areQuestionsAndAnswersSwapped:
                    session.areQuestionsAndAnswersSwapped,
                date: session.date,
                time: session.time,
                duration: null,
                notificationTime: session.notificationTime,
                notificationStatus: session.notificationStatus,
              ),
            ),
          ),
        ).called(1);
      },
    );

    blocTest(
      'notification time not selected',
      build: () => bloc,
      act: (_) {
        bloc.add(SessionCreatorEventGroupSelected(groupId: session.groupId));
        bloc.add(SessionCreatorEventDateSelected(date: session.date));
        bloc.add(SessionCreatorEventTimeSelected(time: session.time));
        bloc.add(SessionCreatorEventDurationSelected(
          duration: session.duration!,
        ));
        bloc.add(SessionCreatorEventSubmit());
      },
      verify: (_) {
        verify(
          () => sessionsBloc.add(
            SessionsEventAddSession(
              session: createSession(
                groupId: session.groupId,
                flashcardsType: session.flashcardsType,
                areQuestionsAndAnswersSwapped:
                    session.areQuestionsAndAnswersSwapped,
                date: session.date,
                time: session.time,
                duration: session.duration,
                notificationTime: null,
                notificationStatus: null,
              ),
            ),
          ),
        ).called(1);
      },
    );
  });

  blocTest(
    'submit edit mode, notification as null',
    build: () => bloc,
    act: (_) {
      bloc.add(
        SessionCreatorEventInitialize(
          mode: SessionCreatorEditMode(session: session),
        ),
      );
      bloc.add(SessionCreatorEventCleanNotificationTime());
      bloc.add(SessionCreatorEventSubmit());
    },
    verify: (_) {
      verify(
        () => sessionsBloc.add(
          SessionsEventUpdateSession(
            sessionId: session.id,
            groupId: session.groupId,
            date: session.date,
            time: session.time,
            duration: session.duration,
            flashcardsType: session.flashcardsType,
            areQuestionsAndFlashcardsSwapped:
                session.areQuestionsAndAnswersSwapped,
            notificationTime: null,
            notificationStatus: null,
          ),
        ),
      );
    },
  );

  blocTest(
    'submit edit mode, notification time changed to null',
    build: () => bloc,
    act: (_) {
      bloc.add(
        SessionCreatorEventInitialize(
          mode: SessionCreatorEditMode(session: session),
        ),
      );
      bloc.add(SessionCreatorEventCleanNotificationTime());
      bloc.add(SessionCreatorEventSubmit());
    },
    verify: (_) {
      verify(
        () => sessionsBloc.add(
          SessionsEventUpdateSession(
            sessionId: session.id,
            groupId: session.groupId,
            date: session.date,
            time: session.time,
            duration: session.duration,
            flashcardsType: session.flashcardsType,
            areQuestionsAndFlashcardsSwapped:
                session.areQuestionsAndAnswersSwapped,
            notificationTime: null,
            notificationStatus: null,
          ),
        ),
      );
    },
  );

  blocTest(
    'submit edit mode, notification time changed to new value',
    build: () => bloc,
    act: (_) {
      bloc.add(
        SessionCreatorEventInitialize(
          mode: SessionCreatorEditMode(
            session: session.copyWith(
              date: Date.now().addDays(2),
              notificationStatus: NotificationStatus.opened,
            ),
          ),
        ),
      );
      bloc.add(
        SessionCreatorEventNotificationTimeSelected(
          notificationTime: const Time(hour: 12, minute: 0),
        ),
      );
      bloc.add(SessionCreatorEventSubmit());
    },
    verify: (_) {
      verify(
        () => sessionsBloc.add(
          SessionsEventUpdateSession(
            sessionId: session.id,
            groupId: session.groupId,
            date: Date.now().addDays(2),
            time: session.time,
            duration: session.duration,
            flashcardsType: session.flashcardsType,
            areQuestionsAndFlashcardsSwapped:
                session.areQuestionsAndAnswersSwapped,
            notificationTime: const Time(hour: 12, minute: 0),
            notificationStatus: NotificationStatus.opened,
          ),
        ),
      );
    },
  );

  blocTest(
    'submit edit mode, notification time changed from null to new value',
    build: () => bloc,
    act: (_) {
      bloc.add(
        SessionCreatorEventInitialize(
          mode: SessionCreatorEditMode(
            session: session.copyWith(
              date: Date.now().addDays(2),
              notificationTime: null,
              notificationStatus: null,
            ),
          ),
        ),
      );
      bloc.add(
        SessionCreatorEventNotificationTimeSelected(
          notificationTime: const Time(hour: 12, minute: 0),
        ),
      );
      bloc.add(SessionCreatorEventSubmit());
    },
    verify: (_) {
      verify(
        () => sessionsBloc.add(
          SessionsEventUpdateSession(
            sessionId: session.id,
            groupId: session.groupId,
            date: Date.now().addDays(2),
            time: session.time,
            duration: session.duration,
            flashcardsType: session.flashcardsType,
            areQuestionsAndFlashcardsSwapped:
                session.areQuestionsAndAnswersSwapped,
            notificationTime: const Time(hour: 12, minute: 0),
            notificationStatus: NotificationStatus.incoming,
          ),
        ),
      );
    },
  );
}
