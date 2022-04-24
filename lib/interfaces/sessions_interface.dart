import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter/material.dart';
import '../models/changed_document.dart';

abstract class SessionsInterface {
  Stream<List<ChangedDocument<Session>>> getSessionsSnapshots();

  Future<void> addNewSession(Session session);

  Future<void> updateSession({
    required String sessionId,
    String? groupId,
    FlashcardsType? flashcardsType,
    bool? areQuestionsAndAnswersSwapped,
    DateTime? date,
    TimeOfDay? time,
    TimeOfDay? duration,
    TimeOfDay? notificationTime,
  });

  Future<void> removeSession(String sessionId);
}
