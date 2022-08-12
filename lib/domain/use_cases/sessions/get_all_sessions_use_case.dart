import '../../../domain/entities/session.dart';
import '../../../interfaces/sessions_interface.dart';

class GetAllSessionsUseCase {
  late final SessionsInterface _sessionsInterface;

  GetAllSessionsUseCase({
    required SessionsInterface sessionsInterface,
  }) {
    _sessionsInterface = sessionsInterface;
  }

  Stream<List<Session>> execute() {
    return _sessionsInterface.allSessions$;
  }
}
