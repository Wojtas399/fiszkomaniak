import 'package:rxdart/rxdart.dart';
import '../../firebase/fire_document.dart';
import '../../firebase/fire_extensions.dart';
import '../../firebase/models/session_db_model.dart';
import '../../firebase/services/fire_sessions_service.dart';
import '../../interfaces/sessions_interface.dart';
import '../../models/date_model.dart';
import '../../models/time_model.dart';
import '../entities/session.dart';

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
    if (_isSessionLoaded(sessionId)) {
      return allSessions$.map(
        (List<Session> sessions) {
          final List<Session?> sessionsForSearching = [...sessions];
          return sessionsForSearching.firstWhere(
            (Session? session) => session?.id == sessionId,
            orElse: () => null,
          );
        },
      ).whereType<Session>();
    }
    return Rx.fromCallable(() async => await _loadSessionFromDb(sessionId))
        .whereType<Session>()
        .doOnData((Session session) => _addSessionToList(session));
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
  Future<String?> addNewSession({
    required String groupId,
    required FlashcardsType flashcardsType,
    required bool areQuestionsAndAnswersSwapped,
    required Date date,
    required Time startTime,
    required Duration? duration,
    required Time? notificationTime,
  }) async {
    final dbSession = await _fireSessionsService.addNewSession(
      groupId: groupId,
      flashcardsType: flashcardsType.toDbString(),
      areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
      date: date.toDbString(),
      time: startTime.toDbString(),
      duration: duration?.toDbString(),
      notificationTime: notificationTime?.toDbString(),
    );
    final Session? session = _convertSessionDbModelToSession(dbSession);
    if (session != null) {
      _addSessionToList(session);
    }
    return dbSession?.id;
  }

  @override
  Future<Session?> updateSession({
    required String sessionId,
    String? groupId,
    FlashcardsType? flashcardsType,
    bool? areQuestionsAndAnswersSwapped,
    Date? date,
    Time? startTime,
    Duration? duration,
    Time? notificationTime,
  }) async {
    final updatedDbSession = await _fireSessionsService.updateSession(
      sessionId: sessionId,
      groupId: groupId,
      flashcardsType: flashcardsType?.toDbString(),
      areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
      date: date?.toDbString(),
      time: startTime?.toDbString(),
      duration: duration?.toDbString(),
      notificationTime: notificationTime?.toDbString(),
    );
    final Session? updatedSession = _convertSessionDbModelToSession(
      updatedDbSession,
    );
    if (updatedSession != null) {
      _updateSessionInList(updatedSession);
    }
    return updatedSession;
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    await _fireSessionsService.removeSession(sessionId);
    _removeSessionFromList(sessionId);
  }

  void _addSessionToList(Session session) {
    final List<Session> updatedSessions = [..._allSessions$.value];
    updatedSessions.add(session);
    _allSessions$.add(updatedSessions.toSet().toList());
  }

  void _updateSessionInList(Session updatedSession) {
    final List<Session> updatedSessions = [..._allSessions$.value];
    final updatedSessionIndex = updatedSessions.indexWhere(
      (Session session) => session.id == updatedSession.id,
    );
    updatedSessions[updatedSessionIndex] = updatedSession;
    _allSessions$.add(updatedSessions);
  }

  void _removeSessionFromList(String sessionId) {
    final List<Session> updatedSessions = [..._allSessions$.value];
    updatedSessions.removeWhere((Session session) => session.id == sessionId);
    _allSessions$.add(updatedSessions);
  }

  bool _isSessionLoaded(String sessionId) {
    return _allSessions$.value
        .map((Session session) => session.id)
        .contains(sessionId);
  }

  Future<Session?> _loadSessionFromDb(String sessionId) async {
    final sessionFromDb = await _fireSessionsService.loadSessionById(
      sessionId: sessionId,
    );
    return _convertSessionDbModelToSession(sessionFromDb);
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
    final String? startTimeStr = sessionData?.time;
    final String? durationStr = sessionData?.duration;
    final String? notificationTimeStr = sessionData?.notificationTime;
    if (sessionId != null &&
        groupId != null &&
        flashcardsType != null &&
        areQuestionsAndAnswersSwapped != null &&
        dateStr != null &&
        startTimeStr != null) {
      return Session(
        id: sessionId,
        groupId: groupId,
        flashcardsType: flashcardsType,
        areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
        date: dateStr.toDate(),
        startTime: startTimeStr.toTime(),
        duration: durationStr?.toDuration(),
        notificationTime: notificationTimeStr?.toTime(),
      );
    }
    return null;
  }
}
