import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/time_model.dart';

class AddSessionUseCase {
  late final SessionsInterface _sessionsInterface;

  AddSessionUseCase({required SessionsInterface sessionsInterface}) {
    _sessionsInterface = sessionsInterface;
  }

  Future<void> execute({
    required String groupId,
    required FlashcardsType flashcardsType,
    required bool areQuestionsAndAnswersSwapped,
    required Date date,
    required Time startTime,
    required Duration? duration,
    required Time? notificationTime,
  }) async {
    await _sessionsInterface.addNewSession(
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
