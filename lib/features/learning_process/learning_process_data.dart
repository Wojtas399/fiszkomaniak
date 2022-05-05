import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../models/session_model.dart';

class LearningProcessData extends Equatable {
  final String? sessionId;
  final String groupId;
  final TimeOfDay? duration;
  final FlashcardsType flashcardsType;
  final bool areQuestionsAndAnswersSwapped;

  const LearningProcessData({
    required this.groupId,
    required this.flashcardsType,
    required this.areQuestionsAndAnswersSwapped,
    this.sessionId,
    this.duration,
  });

  @override
  List<Object> get props => [
        groupId,
        flashcardsType,
        areQuestionsAndAnswersSwapped,
        sessionId ?? '',
        duration ?? '',
      ];
}

LearningProcessData createLearningProcessData({
  String? sessionId,
  String? groupId,
  TimeOfDay? duration,
  FlashcardsType? flashcardsType,
  bool? areQuestionsAndAnswersSwapped,
}) {
  return LearningProcessData(
    sessionId: sessionId,
    groupId: groupId ?? '',
    duration: duration,
    flashcardsType: flashcardsType ?? FlashcardsType.all,
    areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped ?? false,
  );
}
