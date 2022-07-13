import 'package:fiszkomaniak/interfaces/sessions_interface.dart';

class LoadAllSessionsUseCase {
  late final SessionsInterface _sessionsInterface;

  LoadAllSessionsUseCase({
    required SessionsInterface sessionsInterface,
  }) {
    _sessionsInterface = sessionsInterface;
  }

  Future<void> execute() async {
    await _sessionsInterface.loadAllSessions();
  }
}
