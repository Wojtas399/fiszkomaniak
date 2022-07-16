import 'package:fiszkomaniak/interfaces/sessions_interface.dart';

class RemoveSessionUseCase {
  late final SessionsInterface _sessionsInterface;

  RemoveSessionUseCase({
    required SessionsInterface sessionsInterface,
  }) {
    _sessionsInterface = sessionsInterface;
  }

  Future<void> execute({required String sessionId}) async {
    await _sessionsInterface.removeSession(sessionId);
  }
}
