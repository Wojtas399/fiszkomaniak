import 'package:fiszkomaniak/domain/use_cases/sessions/load_all_sessions_use_case.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSessionsInterface extends Mock implements SessionsInterface {}

void main() {
  final sessionsInterface = MockSessionsInterface();
  final useCase = LoadAllSessionsUseCase(sessionsInterface: sessionsInterface);

  test(
    'should call method responsible for loading all sessions',
    () async {
      when(
        () => sessionsInterface.loadAllSessions(),
      ).thenAnswer((_) async => '');

      await useCase.execute();

      verify(() => sessionsInterface.loadAllSessions()).called(1);
    },
  );
}
