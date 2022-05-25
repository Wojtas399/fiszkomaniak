import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/models/fire_doc_model.dart';
import 'package:fiszkomaniak/firebase/models/session_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_sessions_service.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/models/changed_document.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter/material.dart';
import '../firebase/fire_converters.dart';

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
      flashcardsType:
          FireConverters.convertFlashcardsTypeToString(session.flashcardsType),
      areQuestionsAndAnswersSwapped: session.areQuestionsAndAnswersSwapped,
      date: FireConverters.convertDateTimeToString(session.date),
      time: FireConverters.convertTimeOfDayToString(session.time),
      duration: FireConverters.convertDurationToString(session.duration),
      notificationTime:
          FireConverters.convertTimeOfDayToString(session.notificationTime),
    ));
    return id;
  }

  @override
  Future<void> updateSession({
    required String sessionId,
    String? groupId,
    FlashcardsType? flashcardsType,
    bool? areQuestionsAndAnswersSwapped,
    DateTime? date,
    TimeOfDay? time,
    Duration? duration,
    TimeOfDay? notificationTime,
  }) async {
    await _fireSessionsService.updateSession(
      FireDoc(
        id: sessionId,
        doc: SessionDbModel(
          groupId: groupId,
          flashcardsType: FireConverters.convertFlashcardsTypeToString(
            flashcardsType,
          ),
          areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
          date: date != null
              ? FireConverters.convertDateTimeToString(date)
              : null,
          time: FireConverters.convertTimeOfDayToString(time),
          duration: FireConverters.convertDurationToString(duration),
          notificationTime: FireConverters.convertTimeOfDayToString(
            notificationTime,
          ),
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
        FireConverters.convertStringToFlashcardsType(docData?.flashcardsType);
    final bool? areQuestionsAndAnswersSwapped =
        docData?.areQuestionsAndAnswersSwapped;
    final String? date = docData?.date;
    final TimeOfDay? time =
        FireConverters.convertStringToTimeOfDay(docData?.time);
    final Duration? duration =
        FireConverters.convertStringToDuration(docData?.duration);
    final TimeOfDay? notificationTime =
        FireConverters.convertStringToTimeOfDay(docData?.notificationTime);
    if (groupId != null &&
        flashcardsType != null &&
        areQuestionsAndAnswersSwapped != null &&
        date != null &&
        time != null) {
      return ChangedDocument(
        changeType: FireConverters.convertChangeType(docChange.type),
        doc: Session(
          id: docChange.doc.id,
          groupId: groupId,
          flashcardsType: flashcardsType,
          areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
          date: FireConverters.convertStringToDateTime(date),
          time: time,
          duration: duration,
          notificationTime: notificationTime,
        ),
      );
    }
    return null;
  }
}
