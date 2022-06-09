import 'package:fiszkomaniak/models/session_model.dart';
import '../models/changed_document.dart';
import '../models/date_model.dart';
import '../models/time_model.dart';

abstract class SessionsInterface {
  Stream<List<ChangedDocument<Session>>> getSessionsSnapshots();

  Future<String> addNewSession(Session session);

  Future<void> updateSession({
    required String sessionId,
    String? groupId,
    FlashcardsType? flashcardsType,
    bool? areQuestionsAndAnswersSwapped,
    Date? date,
    Time? time,
    Duration? duration,
    Time? notificationTime,
  });

  Future<void> removeSession(String sessionId);
}
