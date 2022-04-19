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
}
