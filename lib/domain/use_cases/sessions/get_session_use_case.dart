import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import '../../entities/session.dart';

class GetSessionUseCase {
  late final SessionsInterface _sessionsInterface;

  GetSessionUseCase({
    required SessionsInterface sessionsInterface,
  }) {
    _sessionsInterface = sessionsInterface;
  }

  Stream<Session> execute({required String sessionId}) {
    return _sessionsInterface.getSessionById(sessionId);
  }
}
