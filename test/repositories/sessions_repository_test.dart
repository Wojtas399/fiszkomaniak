import 'package:fiszkomaniak/firebase/models/fire_doc_model.dart';
import 'package:fiszkomaniak/firebase/models/session_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_sessions_service.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:fiszkomaniak/repositories/sessions_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFireSessionsService extends Mock implements FireSessionsService {}

void main() {
  final FireSessionsService fireSessionsService = MockFireSessionsService();
  late SessionsRepository repository;

  setUp(() {
    repository = SessionsRepository(fireSessionsService: fireSessionsService);
  });

  tearDown(() {
    reset(fireSessionsService);
  });

  test('add new session', () async {
    const SessionDbModel expectedDataToCall = SessionDbModel(
      groupId: 'g1',
      flashcardsType: 'remembered',
      areQuestionsAndAnswersSwapped: true,
      date: '2022-04-19',
      time: '12:30',
      duration: '00:30',
      notificationTime: null,
    );
    when(() => fireSessionsService.addNewSession(expectedDataToCall))
        .thenAnswer((_) async => '');

    await repository.addNewSession(createSession(
      groupId: 'g1',
      flashcardsType: FlashcardsType.remembered,
      areQuestionsAndAnswersSwapped: true,
      date: DateTime(2022, 4, 19),
      time: const TimeOfDay(hour: 12, minute: 30),
      duration: const TimeOfDay(hour: 0, minute: 30),
      notificationTime: null,
    ));

    verify(
      () => fireSessionsService.addNewSession(expectedDataToCall),
    ).called(1);
  });

  test('update session', () async {
    const String newGroupId = 'g2';
    final DateTime newDate = DateTime(2022, 1, 1);
    const TimeOfDay newDuration = TimeOfDay(hour: 0, minute: 45);
    const FireDoc<SessionDbModel> fireDoc = FireDoc(
      id: 's1',
      doc: SessionDbModel(
        groupId: newGroupId,
        flashcardsType: null,
        areQuestionsAndAnswersSwapped: null,
        date: '2022-01-01',
        time: null,
        duration: '00:45',
        notificationTime: null,
      ),
    );
    when(() => fireSessionsService.updateSession(fireDoc))
        .thenAnswer((_) async => '');

    await repository.updateSession(
      sessionId: 's1',
      groupId: newGroupId,
      date: newDate,
      duration: newDuration,
    );

    verify(() => fireSessionsService.updateSession(fireDoc)).called(1);
  });

  test('remove session', () async {
    when(() => fireSessionsService.removeSession('s1'))
        .thenAnswer((_) async => '');

    await repository.removeSession('s1');

    verify(() => fireSessionsService.removeSession('s1')).called(1);
  });

  test('remove sessions by groups ids', () async {
    when(() => fireSessionsService.removeSessionsByGroupsIds(['g1', 'g2']))
        .thenAnswer((_) async => '');

    await repository.removeSessionsByGroupsIds(['g1', 'g2']);

    verify(() => fireSessionsService.removeSessionsByGroupsIds(['g1', 'g2']))
        .called(1);
  });
}
