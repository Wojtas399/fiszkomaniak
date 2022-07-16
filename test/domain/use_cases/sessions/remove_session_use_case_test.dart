import 'package:fiszkomaniak/domain/use_cases/sessions/remove_session_use_case.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSessionsInterface extends Mock implements SessionsInterface {}

void main() {
  final sessionsInterface = MockSessionsInterface();
  final useCase = RemoveSessionUseCase(sessionsInterface: sessionsInterface);

  test(
    'should call method responsible for removing session',
    () async {
      when(
        () => sessionsInterface.removeSession('s1'),
      ).thenAnswer((_) async => '');

      await useCase.execute(sessionId: 's1');

      verify(() => sessionsInterface.removeSession('s1')).called(1);
    },
  );
}
