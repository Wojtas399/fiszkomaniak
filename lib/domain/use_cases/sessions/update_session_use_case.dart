import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/time_model.dart';

class UpdateSessionUseCase {
  late final SessionsInterface _sessionsInterface;

  UpdateSessionUseCase({required SessionsInterface sessionsInterface}) {
    _sessionsInterface = sessionsInterface;
  }

  Future<void> execute({
    required String sessionId,
    String? groupId,
    FlashcardsType? flashcardsType,
    bool? areQuestionsAndAnswersSwapped,
    Date? date,
    Time? startTime,
    Duration? duration,
    Time? notificationTime,
  }) async {
    await _sessionsInterface.updateSession(
      sessionId: sessionId,
      groupId: groupId,
      flashcardsType: flashcardsType,
      areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
      date: date,
      startTime: startTime,
      duration: duration,
      notificationTime: notificationTime,
    );
  }
}
