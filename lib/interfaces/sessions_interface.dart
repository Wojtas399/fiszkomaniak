import '../domain/entities/session.dart';
import '../models/date_model.dart';
import '../models/time_model.dart';

abstract class SessionsInterface {
  Stream<List<Session>> get allSessions$;

  Stream<Session> getSessionById(String sessionId);

  Future<void> loadAllSessions();

  Future<String?> addNewSession({
    required String groupId,
    required FlashcardsType flashcardsType,
    required bool areQuestionsAndAnswersSwapped,
    required Date date,
    required Time startTime,
    required Duration? duration,
    required Time? notificationTime,
  });

  Future<Session?> updateSession({
    required String sessionId,
    String? groupId,
    FlashcardsType? flashcardsType,
    bool? areQuestionsAndAnswersSwapped,
    Date? date,
    Time? startTime,
    Duration? duration,
    Time? notificationTime,
  });

  Future<void> deleteSession(String sessionId);
}
