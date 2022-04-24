import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/models/fire_doc_model.dart';
import 'package:fiszkomaniak/firebase/models/session_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_sessions_service.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/models/changed_document.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter/material.dart';
import '../firebase/fire_utils.dart';

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
  Future<void> addNewSession(Session session) async {
    await _fireSessionsService.addNewSession(SessionDbModel(
      groupId: session.groupId,
      flashcardsType: _convertFlashcardsTypeToString(session.flashcardsType),
      areQuestionsAndAnswersSwapped: session.areQuestionsAndAnswersSwapped,
      date: _convertDateTimeToString(session.date),
      time: _convertTimeOfDayToString(session.time),
      duration: _convertTimeOfDayToString(session.duration),
      notificationTime: _convertTimeOfDayToString(session.notificationTime),
    ));
  }

  @override
  Future<void> updateSession({
    required String sessionId,
    String? groupId,
    FlashcardsType? flashcardsType,
    bool? areQuestionsAndAnswersSwapped,
    DateTime? date,
    TimeOfDay? time,
    TimeOfDay? duration,
    TimeOfDay? notificationTime,
  }) async {
    await _fireSessionsService.updateSession(
      FireDoc(
        id: sessionId,
        doc: SessionDbModel(
          groupId: groupId,
          flashcardsType: _convertFlashcardsTypeToString(flashcardsType),
          areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
          date: _convertDateTimeToString(date),
          time: _convertTimeOfDayToString(time),
          duration: _convertTimeOfDayToString(duration),
          notificationTime: _convertTimeOfDayToString(notificationTime),
        ),
      ),
    );
  }

  @override
  Future<void> removeSession(String sessionId) async {
    await _fireSessionsService.removeSession(sessionId);
  }

  @override
  Future<void> removeSessionsByGroupsIds(List<String> groupsIds) async {
    await _fireSessionsService.removeSessionsByGroupsIds(groupsIds);
  }

  ChangedDocument<Session>? _convertFireDocumentToChangedDocumentModel(
    DocumentChange<SessionDbModel> docChange,
  ) {
    final docData = docChange.doc.data();
    final String? groupId = docData?.groupId;
    final FlashcardsType? flashcardsType = _convertStringToFlashcardsType(
      docData?.flashcardsType,
    );
    final bool? areQuestionsAndAnswersSwapped =
        docData?.areQuestionsAndAnswersSwapped;
    final String? date = docData?.date;
    final TimeOfDay? time = _convertStringToTimeOfDay(docData?.time);
    final TimeOfDay? duration = _convertStringToTimeOfDay(docData?.duration);
    final TimeOfDay? notificationTime = _convertStringToTimeOfDay(
      docData?.notificationTime,
    );
    if (groupId != null &&
        flashcardsType != null &&
        areQuestionsAndAnswersSwapped != null &&
        date != null &&
        time != null) {
      return ChangedDocument(
        changeType: FireUtils.convertChangeType(docChange.type),
        doc: Session(
          id: docChange.doc.id,
          groupId: groupId,
          flashcardsType: flashcardsType,
          areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
          date: _convertStringToDateTime(date),
          time: time,
          duration: duration,
          notificationTime: notificationTime,
        ),
      );
    }
    return null;
  }

  String? _convertFlashcardsTypeToString(FlashcardsType? type) {
    if (type == null) {
      return null;
    }
    switch (type) {
      case FlashcardsType.all:
        return 'all';
      case FlashcardsType.remembered:
        return 'remembered';
      case FlashcardsType.notRemembered:
        return 'notRemembered';
    }
  }

  FlashcardsType? _convertStringToFlashcardsType(String? type) {
    switch (type) {
      case 'all':
        return FlashcardsType.all;
      case 'remembered':
        return FlashcardsType.remembered;
      case 'notRemembered':
        return FlashcardsType.notRemembered;
      default:
        return null;
    }
  }

  String? _convertDateTimeToString(DateTime? date) {
    if (date == null) {
      return null;
    }
    final String month = _convertNumberToDateTimeString(date.month);
    final String day = _convertNumberToDateTimeString(date.day);
    return '${date.year}-$month-$day';
  }

  DateTime _convertStringToDateTime(String date) {
    final List<String> splitDate = date.split('-');
    final int year = int.parse(splitDate[0]);
    final int month = int.parse(splitDate[1]);
    final int day = int.parse(splitDate[2]);
    return DateTime(year, month, day);
  }

  String? _convertTimeOfDayToString(TimeOfDay? time) {
    if (time == null) {
      return null;
    }
    final String hours = _convertNumberToDateTimeString(time.hour);
    final String minutes = _convertNumberToDateTimeString(time.minute);
    return '$hours:$minutes';
  }

  TimeOfDay? _convertStringToTimeOfDay(String? time) {
    if (time == null) {
      return null;
    }
    final List<String> splitTime = time.split(':');
    final int hours = int.parse(splitTime[0]);
    final int minutes = int.parse(splitTime[1]);
    return TimeOfDay(hour: hours, minute: minutes);
  }

  String _convertNumberToDateTimeString(int number) {
    return number < 10 ? '0$number' : '$number';
  }
}
