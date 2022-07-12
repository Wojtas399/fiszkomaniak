import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:fiszkomaniak/domain/repositories/sessions_repository.dart';
import 'package:fiszkomaniak/firebase/fire_document.dart';
import 'package:fiszkomaniak/firebase/models/session_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_sessions_service.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/time_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFireSessionsService extends Mock implements FireSessionsService {}

void main() {
  final fireSessionsService = MockFireSessionsService();
  late SessionsRepository repository;
  final List<FireDocument<SessionDbModel>> dbSessions = [
    FireDocument(
      id: 's1',
      data: createSessionDbModel(
        groupId: 'g1',
        flashcardsType: 'remembered',
        date: '2022-05-05',
        time: '12:30',
        duration: '00:30',
      ),
    ),
    FireDocument(
      id: 's2',
      data: createSessionDbModel(
        groupId: 'g2',
        flashcardsType: 'notRemembered',
        date: '2022-03-03',
        time: '09:00',
        notificationTime: '06:06',
      ),
    )
  ];
  final List<Session> sessions = [
    createSession(
      id: 's1',
      groupId: 'g1',
      flashcardsType: FlashcardsType.remembered,
      date: const Date(year: 2022, month: 5, day: 5),
      startTime: const Time(hour: 12, minute: 30),
      duration: const Duration(minutes: 30),
    ),
    createSession(
      id: 's2',
      groupId: 'g2',
      flashcardsType: FlashcardsType.notRemembered,
      date: const Date(year: 2022, month: 3, day: 3),
      startTime: const Time(hour: 9, minute: 0),
      notificationTime: const Time(hour: 6, minute: 6),
    ),
  ];

  setUp(() async {
    repository = SessionsRepository(fireSessionsService: fireSessionsService);
    when(
      () => fireSessionsService.loadAllSessions(),
    ).thenAnswer((_) async => dbSessions);
    await repository.loadAllSessions();
  });

  tearDown(() {
    reset(fireSessionsService);
  });

  test(
    'get all sessions, should return stream which contains all sessions',
    () async {
      final Stream<List<Session>> sessions$ = repository.allSessions$;

      expect(await sessions$.first, sessions);
    },
  );

  test(
    'get session by id, should return stream which contains expected session',
    () async {
      final Session expectedSession = sessions[0];

      final Stream<Session> session$ = repository.getSessionById('s1');

      expect(await session$.first, expectedSession);
    },
  );

  test(
    'load all sessions, should load sessions from db',
    () async {
      verify(() => fireSessionsService.loadAllSessions()).called(1);
    },
  );

  test(
    'add new session, should call method responsible for adding new session to db and then should add this new session to all sessions list',
    () async {
      final SessionDbModel newSessionDbModel = createSessionDbModel(
        groupId: 'g1',
        flashcardsType: 'remembered',
        date: '2022-01-01',
        time: '16:00',
      );
      final FireDocument<SessionDbModel> newDbSession = FireDocument(
        id: 's1',
        data: newSessionDbModel,
      );
      final Session newSession = createSession(
        id: 's1',
        groupId: 'g1',
        flashcardsType: FlashcardsType.remembered,
        date: const Date(year: 2022, month: 1, day: 1),
        startTime: const Time(hour: 16, minute: 0),
      );
      when(
        () => fireSessionsService.addNewSession(
          groupId: 'g1',
          flashcardsType: 'remembered',
          areQuestionsAndAnswersSwapped: false,
          date: '2022-01-01',
          time: '16:00',
          duration: null,
          notificationTime: null,
        ),
      ).thenAnswer((_) async => newDbSession);

      await repository.addNewSession(
        groupId: 'g1',
        flashcardsType: FlashcardsType.remembered,
        areQuestionsAndAnswersSwapped: false,
        date: const Date(year: 2022, month: 1, day: 1),
        startTime: const Time(hour: 16, minute: 0),
        duration: null,
        notificationTime: null,
      );

      verify(
        () => fireSessionsService.addNewSession(
          groupId: 'g1',
          flashcardsType: 'remembered',
          areQuestionsAndAnswersSwapped: false,
          date: '2022-01-01',
          time: '16:00',
          duration: null,
          notificationTime: null,
        ),
      ).called(1);
      expect(
        await repository.allSessions$.first,
        [...sessions, newSession],
      );
    },
  );

  test(
    'update session, should call method responsible for updating session and the should update this session in all sessions list',
    () async {
      final SessionDbModel updatedSessionDbModel = createSessionDbModel(
        groupId: 'g3',
        flashcardsType: 'notRemembered',
        date: '2022-05-05',
        time: '15:00',
        duration: '00:30',
      );
      final FireDocument<SessionDbModel> dbUpdatedSession = FireDocument(
        id: 's1',
        data: updatedSessionDbModel,
      );
      final Session updatedSession = sessions[0].copyWith(
        groupId: 'g3',
        flashcardsType: FlashcardsType.notRemembered,
        startTime: const Time(hour: 15, minute: 0),
      );
      when(
        () => fireSessionsService.updateSession(
          sessionId: 's1',
          groupId: 'g3',
          flashcardsType: 'notRemembered',
          time: '15:00',
        ),
      ).thenAnswer((_) async => dbUpdatedSession);

      await repository.updateSession(
        sessionId: 's1',
        groupId: 'g3',
        flashcardsType: FlashcardsType.notRemembered,
        startTime: const Time(hour: 15, minute: 0),
      );

      verify(
        () => fireSessionsService.updateSession(
          sessionId: 's1',
          groupId: 'g3',
          flashcardsType: 'notRemembered',
          time: '15:00',
        ),
      ).called(1);
      expect(
        await repository.allSessions$.first,
        [updatedSession, sessions[1]],
      );
    },
  );

  test(
    'remove session, should call method responsible for removing session and then should remove this session from all sessions list',
    () async {
      when(
        () => fireSessionsService.removeSession('s2'),
      ).thenAnswer((_) async => '');

      await repository.removeSession('s2');

      verify(() => fireSessionsService.removeSession('s2')).called(1);
      expect(
        await repository.allSessions$.first,
        [sessions[0]],
      );
    },
  );
}
