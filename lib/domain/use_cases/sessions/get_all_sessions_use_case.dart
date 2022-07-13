import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';

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
