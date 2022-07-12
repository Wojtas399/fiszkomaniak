import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/add_session_use_case.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/time_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSessionsInterface extends Mock implements SessionsInterface {}

void main() {
  final sessionsInterface = MockSessionsInterface();
  final useCase = AddSessionUseCase(sessionsInterface: sessionsInterface);

  test(
    'should call method responsible for adding new session',
    () async {
      when(
        () => sessionsInterface.addNewSession(
          groupId: 'g1',
          flashcardsType: FlashcardsType.remembered,
          areQuestionsAndAnswersSwapped: false,
          date: const Date(year: 2022, month: 1, day: 1),
          startTime: const Time(hour: 12, minute: 30),
          duration: const Duration(minutes: 30),
          notificationTime: const Time(hour: 10, minute: 0),
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute(
        groupId: 'g1',
        flashcardsType: FlashcardsType.remembered,
        areQuestionsAndAnswersSwapped: false,
        date: const Date(year: 2022, month: 1, day: 1),
        startTime: const Time(hour: 12, minute: 30),
        duration: const Duration(minutes: 30),
        notificationTime: const Time(hour: 10, minute: 0),
      );

      verify(
        () => sessionsInterface.addNewSession(
          groupId: 'g1',
          flashcardsType: FlashcardsType.remembered,
          areQuestionsAndAnswersSwapped: false,
          date: const Date(year: 2022, month: 1, day: 1),
          startTime: const Time(hour: 12, minute: 30),
          duration: const Duration(minutes: 30),
          notificationTime: const Time(hour: 10, minute: 0),
        ),
      ).called(1);
    },
  );
}
