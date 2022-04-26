import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../models/session_model.dart';

class LearningProcessState extends Equatable {
  final LearningProcessData? data;

  const LearningProcessState({this.data});

  LearningProcessState copyWith({
    LearningProcessData? data,
  }) {
    return LearningProcessState(
      data: data ?? this.data,
    );
  }

  @override
  List<Object> get props => [
        data ?? '',
      ];
}

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
