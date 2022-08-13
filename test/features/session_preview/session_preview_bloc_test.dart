import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/get_session_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/delete_session_use_case.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_bloc.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_mode.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

class MockGetSessionUseCase extends Mock implements GetSessionUseCase {}

class MockGetGroupUseCase extends Mock implements GetGroupUseCase {}

class MockGetCourseUseCase extends Mock implements GetCourseUseCase {}

class MockDeleteSessionUseCase extends Mock implements DeleteSessionUseCase {}

void main() {
  final getSessionUseCase = MockGetSessionUseCase();
  final getGroupUseCase = MockGetGroupUseCase();
  final getCourseUseCase = MockGetCourseUseCase();
  final deleteSessionUseCase = MockDeleteSessionUseCase();

  SessionPreviewBloc createBloc({
    BlocStatus status = const BlocStatusInitial(),
    Session? session,
    Duration? duration,
    bool areQuestionsAndAnswersSwapped = false,
  }) {
    return SessionPreviewBloc(
      getSessionUseCase: getSessionUseCase,
      getGroupUseCase: getGroupUseCase,
      getCourseUseCase: getCourseUseCase,
      deleteSessionUseCase: deleteSessionUseCase,
      status: status,
      session: session,
      duration: duration,
      areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
    );
  }

  SessionPreviewState createState({
    BlocStatus status = const BlocStatusInProgress(),
    SessionPreviewMode? mode,
    Session? session,
    Group? group,
    String? courseName,
    Duration? duration,
    FlashcardsType flashcardsType = FlashcardsType.all,
    bool areQuestionsAndAnswersSwapped = false,
  }) {
    return SessionPreviewState(
      status: status,
      mode: mode,
      session: session,
      group: group,
      courseName: courseName,
      duration: duration,
      flashcardsType: flashcardsType,
      areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
    );
  }

  tearDown(() {
    reset(getSessionUseCase);
    reset(getGroupUseCase);
    reset(getCourseUseCase);
    reset(deleteSessionUseCase);
  });

  group(
    'initialize',
    () {
      final Session session = createSession(
        id: 's1',
        groupId: 'g1',
        duration: const Duration(minutes: 30),
        flashcardsType: FlashcardsType.remembered,
        areQuestionsAndAnswersSwapped: true,
      );
      final Group group = createGroup(
        id: 'g1',
        courseId: 'c1',
        name: 'group 1',
      );
      final Course course = createCourse(id: 'c1', name: 'course name');

      setUp(() {
        when(
          () => getGroupUseCase.execute(groupId: 'g1'),
        ).thenAnswer((_) => Stream.value(group));
        when(
          () => getCourseUseCase.execute(courseId: 'c1'),
        ).thenAnswer((_) => Stream.value(course));
      });

      blocTest(
        'normal mode, should update state with session, matching group and course name',
        build: () => createBloc(),
        setUp: () {
          when(
            () => getSessionUseCase.execute(sessionId: 's1'),
          ).thenAnswer((_) => Stream.value(session));
        },
        act: (SessionPreviewBloc bloc) {
          bloc.add(
            SessionPreviewEventInitialize(
              mode: SessionPreviewModeNormal(sessionId: 's1'),
            ),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusComplete(),
            mode: SessionPreviewModeNormal(sessionId: 's1'),
          ),
          createState(
            mode: SessionPreviewModeNormal(sessionId: 's1'),
            session: session,
            group: group,
            courseName: course.name,
            duration: session.duration,
            flashcardsType: session.flashcardsType,
            areQuestionsAndAnswersSwapped:
                session.areQuestionsAndAnswersSwapped,
          ),
        ],
      );

      blocTest(
        'quick mode, should update state only with matching group and course name',
        build: () => createBloc(),
        act: (SessionPreviewBloc bloc) {
          bloc.add(
            SessionPreviewEventInitialize(
              mode: SessionPreviewModeQuick(groupId: 'g1'),
            ),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusComplete(),
            mode: SessionPreviewModeQuick(groupId: 'g1'),
            group: group,
            courseName: course.name,
          ),
        ],
      );
    },
  );

  group(
    'session updated',
    () {
      final Session session = createSession(
        id: 's1',
        groupId: 'g1',
        duration: const Duration(minutes: 30),
        flashcardsType: FlashcardsType.notRemembered,
        areQuestionsAndAnswersSwapped: false,
      );
      final Group group = createGroup(id: 'g1', courseId: 'c1', name: 'group1');
      final Course course = createCourse(id: 'c1', name: 'course name');

      blocTest(
        'should update state with session, its matching params, group and course name',
        build: () => createBloc(),
        setUp: () {
          when(
            () => getGroupUseCase.execute(groupId: 'g1'),
          ).thenAnswer((_) => Stream.value(group));
          when(
            () => getCourseUseCase.execute(courseId: 'c1'),
          ).thenAnswer((_) => Stream.value(course));
        },
        act: (SessionPreviewBloc bloc) {
          bloc.add(
            SessionPreviewEventSessionUpdated(session: session),
          );
        },
        expect: () => [
          createState(
            session: session,
            group: group,
            courseName: course.name,
            duration: session.duration,
            flashcardsType: session.flashcardsType,
            areQuestionsAndAnswersSwapped:
                session.areQuestionsAndAnswersSwapped,
          ),
        ],
      );
    },
  );

  blocTest(
    'duration changed, should update duration in state',
    build: () => createBloc(),
    act: (SessionPreviewBloc bloc) {
      bloc.add(
        SessionPreviewEventDurationChanged(
          duration: const Duration(minutes: 30),
        ),
      );
    },
    expect: () => [
      createState(
        duration: const Duration(minutes: 30),
      ),
    ],
  );

  blocTest(
    'reset duration, should set duration as null in state',
    build: () => createBloc(
      duration: const Duration(minutes: 30),
    ),
    act: (SessionPreviewBloc bloc) {
      bloc.add(
        SessionPreviewEventResetDuration(),
      );
    },
    expect: () => [
      createState(duration: null),
    ],
  );

  blocTest(
    'flashcards type changed, should update flashcards type in state',
    build: () => createBloc(),
    act: (SessionPreviewBloc bloc) {
      bloc.add(
        SessionPreviewEventFlashcardsTypeChanged(
          flashcardsType: FlashcardsType.remembered,
        ),
      );
    },
    expect: () => [
      createState(
        flashcardsType: FlashcardsType.remembered,
      ),
    ],
  );

  blocTest(
    'swap questions and answers, should negate actual value',
    build: () => createBloc(
      areQuestionsAndAnswersSwapped: true,
    ),
    act: (SessionPreviewBloc bloc) {
      bloc.add(SessionPreviewEventSwapQuestionsAndAnswers());
    },
    expect: () => [
      createState(
        areQuestionsAndAnswersSwapped: false,
      ),
    ],
  );

  group(
    'delete session session',
    () {
      final Session session = createSession(id: 's1', groupId: 'g1');

      setUp(() {
        when(
          () => deleteSessionUseCase.execute(sessionId: session.id),
        ).thenAnswer((_) async => '');
      });

      blocTest(
        'should call use case responsible for deleting session',
        build: () => createBloc(
          session: session,
        ),
        act: (SessionPreviewBloc bloc) {
          bloc.add(
            SessionPreviewEventDeleteSession(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            session: session,
          ),
          createState(
            status: const BlocStatusComplete<SessionPreviewInfo>(
              info: SessionPreviewInfo.sessionHasBeenDeleted,
            ),
            session: session,
          )
        ],
        verify: (_) {
          verify(
            () => deleteSessionUseCase.execute(sessionId: 's1'),
          ).called(1);
        },
      );

      blocTest(
        'should not call use case responsible for removing session if session has not been set in state',
        build: () => createBloc(),
        act: (SessionPreviewBloc bloc) {
          bloc.add(
            SessionPreviewEventDeleteSession(),
          );
        },
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => deleteSessionUseCase.execute(
              sessionId: any(named: 'sessionId'),
            ),
          );
        },
      );
    },
  );
}
