import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/fire_extensions.dart';
import 'package:fiszkomaniak/firebase/models/fire_doc_model.dart';
import 'package:fiszkomaniak/firebase/models/session_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_sessions_service.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/models/changed_document.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import '../models/time_model.dart';

class SessionsRepository implements SessionsInterface {
  late final FireSessionsService _fireSessionsService;

  SessionsRepository({required FireSessionsService fireSessionsService}) {
    _fireSessionsService = fireSessionsService;
  }

  @override
  Stream<List<ChangedDocument<Session>>> getSessionsSnapshots() {
    return _fireSessionsService
        .getSessionsSnapshots()
        .map((snapshot) => snapshot.docChanges)
        .map(
          (docChanges) => docChanges
              .map((element) => _convertFireDocumentToChangedDocumentModel(
                    element,
                  ))
              .whereType<ChangedDocument<Session>>()
              .toList(),
        );
  }

  @override
  Future<String> addNewSession(Session session) async {
    final id = await _fireSessionsService.addNewSession(SessionDbModel(
      groupId: session.groupId,
      flashcardsType: session.flashcardsType.toDbString(),
      areQuestionsAndAnswersSwapped: session.areQuestionsAndAnswersSwapped,
      date: session.date.toDbString(),
      time: session.time.toDbString(),
      duration: session.duration?.toDbString(),
      notificationTime: session.notificationTime?.toDbString(),
      notificationStatus: session.notificationStatus?.toDbString(),
    ));
    return id;
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
    NotificationStatus? notificationStatus,
  }) async {
    await _fireSessionsService.updateSession(
      FireDoc(
        id: sessionId,
        doc: SessionDbModel(
          groupId: groupId,
          flashcardsType: flashcardsType?.toDbString(),
          areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
          date: date?.toDbString(),
          time: time?.toDbString(),
          duration: duration?.toDbString(),
          notificationTime: notificationTime?.toDbString(),
          notificationStatus: notificationStatus?.toDbString(),
        ),
      ),
    );
  }

  @override
  Future<void> removeSession(String sessionId) async {
    await _fireSessionsService.removeSession(sessionId);
  }

  ChangedDocument<Session>? _convertFireDocumentToChangedDocumentModel(
    DocumentChange<SessionDbModel> docChange,
  ) {
    final docData = docChange.doc.data();
    final String? groupId = docData?.groupId;
    final FlashcardsType? flashcardsType =
        docData?.flashcardsType?.toFlashcardsType();
    final bool? areQuestionsAndAnswersSwapped =
        docData?.areQuestionsAndAnswersSwapped;
    final String? dateStr = docData?.date;
    final String? timeStr = docData?.time;
    final String? durationStr = docData?.duration;
    final String? notificationTimeStr = docData?.notificationTime;
    final String? notificationStatusStr = docData?.notificationStatus;
    if (groupId != null &&
        flashcardsType != null &&
        areQuestionsAndAnswersSwapped != null &&
        dateStr != null &&
        timeStr != null) {
      return ChangedDocument(
        changeType: docChange.type.toDbDocChangeType(),
        doc: Session(
          id: docChange.doc.id,
          groupId: groupId,
          flashcardsType: flashcardsType,
          areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
          date: dateStr.toDate(),
          time: timeStr.toTime(),
          duration: durationStr?.toDuration(),
          notificationTime: notificationTimeStr?.toTime(),
          notificationStatus: notificationStatusStr?.toNotificationStatus(),
        ),
      );
    }
    return null;
  }
}
