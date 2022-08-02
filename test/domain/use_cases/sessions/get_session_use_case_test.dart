import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/get_session_use_case.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSessionsInterface extends Mock implements SessionsInterface {}

void main() {
  final sessionsInterface = MockSessionsInterface();
  final useCase = GetSessionUseCase(sessionsInterface: sessionsInterface);

  test(
    'should return stream which contains specific session',
    () async {
      final Session expectedSession = createSession(id: 's1', groupId: 'g1');
      when(
        () => sessionsInterface.getSessionById('s1'),
      ).thenAnswer((_) => Stream.value(expectedSession));

      final Stream<Session> session$ = useCase.execute(sessionId: 's1');

      expect(await session$.first, expectedSession);
      verify(() => sessionsInterface.getSessionById('s1')).called(1);
    },
  );
}
