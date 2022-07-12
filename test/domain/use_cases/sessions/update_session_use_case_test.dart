import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/update_session_use_case.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/time_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSessionsInterface extends Mock implements SessionsInterface {}

void main() {
  final sessionsInterface = MockSessionsInterface();
  final useCase = UpdateSessionUseCase(sessionsInterface: sessionsInterface);

  test(
    'should call method responsible for updating session',
    () async {
      when(
        () => sessionsInterface.updateSession(
          sessionId: 's1',
          groupId: 'g1',
          flashcardsType: FlashcardsType.notRemembered,
          areQuestionsAndAnswersSwapped: true,
          date: const Date(year: 2022, month: 1, day: 1),
          startTime: const Time(hour: 12, minute: 30),
          duration: const Duration(minutes: 30),
          notificationTime: const Time(hour: 10, minute: 30),
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute(
        sessionId: 's1',
        groupId: 'g1',
        flashcardsType: FlashcardsType.notRemembered,
        areQuestionsAndAnswersSwapped: true,
        date: const Date(year: 2022, month: 1, day: 1),
        startTime: const Time(hour: 12, minute: 30),
        duration: const Duration(minutes: 30),
        notificationTime: const Time(hour: 10, minute: 30),
      );

      verify(
        () => sessionsInterface.updateSession(
          sessionId: 's1',
          groupId: 'g1',
          flashcardsType: FlashcardsType.notRemembered,
          areQuestionsAndAnswersSwapped: true,
          date: const Date(year: 2022, month: 1, day: 1),
          startTime: const Time(hour: 12, minute: 30),
          duration: const Duration(minutes: 30),
          notificationTime: const Time(hour: 10, minute: 30),
        ),
      ).called(1);
    },
  );
}
