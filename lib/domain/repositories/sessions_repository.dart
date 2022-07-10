import 'package:fiszkomaniak/firebase/fire_document.dart';
import 'package:fiszkomaniak/firebase/fire_extensions.dart';
import 'package:fiszkomaniak/firebase/models/session_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_sessions_service.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:rxdart/rxdart.dart';
import '../../models/time_model.dart';

class SessionsRepository implements SessionsInterface {
  late final FireSessionsService _fireSessionsService;
  late final _allSessions$ = BehaviorSubject<List<Session>>.seeded([]);

  SessionsRepository({required FireSessionsService fireSessionsService}) {
    _fireSessionsService = fireSessionsService;
  }

  @override
  Stream<List<Session>> get allSessions$ => _allSessions$.stream;

  @override
  Stream<Session> getSessionById(String sessionId) {
    return allSessions$.map(
      (sessions) => sessions.firstWhere((session) => session.id == sessionId),
    );
  }

  @override
  Future<void> loadAllSessions() async {
    final sessions = await _fireSessionsService.loadAllSessions();
    _allSessions$.add(
      sessions
          .map(_convertSessionDbModelToSession)
          .whereType<Session>()
          .toList(),
    );
  }

  @override
  Future<void> addNewSession({
    required String groupId,
    required FlashcardsType flashcardsType,
    required bool areQuestionsAndAnswersSwapped,
    required Date date,
    required Time time,
    required Duration? duration,
    required Time? notificationTime,
  }) async {
    final dbSession = await _fireSessionsService.addNewSession(
      groupId: groupId,
      flashcardsType: flashcardsType.toDbString(),
      areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
      date: date.toDbString(),
      time: time.toDbString(),
      duration: duration?.toDbString(),
      notificationTime: notificationTime?.toDbString(),
    );
    final Session? session = _convertSessionDbModelToSession(dbSession);
    if (session != null) {
      _addSessionToList(session);
    }
  }

  @override
  Future<void> updateSession({
    required String sessionId,
    String? groupId,
    FlashcardsType? flashcardsType,
    bool? areQuestionsAndAnswersSwapped,
    Date? date,
    Time? time,
    Duration? duration,
    Time? notificationTime,
  }) async {
    final updatedDbSession = await _fireSessionsService.updateSession(
      sessionId: sessionId,
      groupId: groupId,
      flashcardsType: flashcardsType?.toDbString(),
      areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
      date: date?.toDbString(),
      time: time?.toDbString(),
      duration: duration?.toDbString(),
      notificationTime: notificationTime?.toDbString(),
    );
    final Session? updatedSession = _convertSessionDbModelToSession(
      updatedDbSession,
    );
    if (updatedSession != null) {
      _updateSessionInList(updatedSession);
    }
  }

  @override
  Future<void> removeSession(String sessionId) async {
    await _fireSessionsService.removeSession(sessionId);
    _removeSessionFromList(sessionId);
  }

  Session? _convertSessionDbModelToSession(
    FireDocument<SessionDbModel>? doc,
  ) {
    final String? sessionId = doc?.id;
    final sessionData = doc?.data;
    final String? groupId = sessionData?.groupId;
    final FlashcardsType? flashcardsType =
        sessionData?.flashcardsType?.toFlashcardsType();
    final bool? areQuestionsAndAnswersSwapped =
        sessionData?.areQuestionsAndAnswersSwapped;
    final String? dateStr = sessionData?.date;
    final String? timeStr = sessionData?.time;
    final String? durationStr = sessionData?.duration;
    final String? notificationTimeStr = sessionData?.notificationTime;
    if (sessionId != null &&
        groupId != null &&
        flashcardsType != null &&
        areQuestionsAndAnswersSwapped != null &&
        dateStr != null &&
        timeStr != null) {
      return Session(
        id: sessionId,
        groupId: groupId,
        flashcardsType: flashcardsType,
        areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
        date: dateStr.toDate(),
        time: timeStr.toTime(),
        duration: durationStr?.toDuration(),
        notificationTime: notificationTimeStr?.toTime(),
      );
    }
    return null;
  }

  void _addSessionToList(Session session) {
    final List<Session> updatedSessions = [..._allSessions$.value];
    updatedSessions.add(session);
    _allSessions$.add(updatedSessions);
  }

  void _updateSessionInList(Session updatedSession) {
    final List<Session> updatedSessions = [..._allSessions$.value];
    final updatedSessionIndex = updatedSessions.indexWhere(
      (session) => session.id == updatedSession.id,
    );
    updatedSessions[updatedSessionIndex] = updatedSession;
    _allSessions$.add(updatedSessions);
  }

  void _removeSessionFromList(String sessionId) {
    final List<Session> updatedSessions = [..._allSessions$.value];
    updatedSessions.removeWhere((session) => session.id == sessionId);
    _allSessions$.add(updatedSessions);
  }
}
