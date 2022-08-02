import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/get_all_sessions_use_case.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSessionsInterface extends Mock implements SessionsInterface {}

void main() {
  final sessionsInterface = MockSessionsInterface();
  final useCase = GetAllSessionsUseCase(sessionsInterface: sessionsInterface);

  test(
    'should return stream which contains all sessions from repo',
    () async {
      final List<Session> expectedSessions = [
        createSession(id: 's1'),
        createSession(id: 's2'),
      ];
      when(
        () => sessionsInterface.allSessions$,
      ).thenAnswer((_) => Stream.value(expectedSessions));

      final Stream<List<Session>> sessions$ = useCase.execute();

      expect(await sessions$.first, expectedSessions);
    },
  );
}
