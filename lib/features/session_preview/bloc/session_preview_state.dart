import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_mode.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter/material.dart';
import '../../../models/group_model.dart';

class SessionPreviewState extends Equatable {
  final SessionPreviewMode? mode;
  final Session? session;
  final Group? group;
  final String? courseName;
  final TimeOfDay? duration;
  final FlashcardsType flashcardsType;
  final bool areQuestionsAndAnswersSwapped;

  const SessionPreviewState({
    this.mode,
    this.session,
    this.group,
    this.courseName,
    this.duration,
    this.flashcardsType = FlashcardsType.all,
    this.areQuestionsAndAnswersSwapped = false,
  });

  DateTime? get date {
    if (mode is SessionPreviewModeNormal) {
      return session?.date;
    } else if (mode is SessionPreviewModeQuick) {
      return DateTime.now();
    }
    return null;
  }

  String? get nameForQuestions => areQuestionsAndAnswersSwapped == true
      ? group?.nameForAnswers
      : group?.nameForQuestions;

  String? get nameForAnswers => areQuestionsAndAnswersSwapped == true
      ? group?.nameForQuestions
      : group?.nameForAnswers;

  SessionPreviewState copyWith({
    SessionPreviewMode? mode,
    Session? session,
    Group? group,
    String? courseName,
    TimeOfDay? duration,
    FlashcardsType? flashcardsType,
    bool? areQuestionsAndAnswersSwapped,
  }) {
    return SessionPreviewState(
      mode: mode ?? this.mode,
      session: session ?? this.session,
      group: group ?? this.group,
      courseName: courseName ?? this.courseName,
      duration: duration,
      flashcardsType: flashcardsType ?? this.flashcardsType,
      areQuestionsAndAnswersSwapped:
          areQuestionsAndAnswersSwapped ?? this.areQuestionsAndAnswersSwapped,
    );
  }

  @override
  List<Object> get props => [
        mode ?? '',
        session ?? '',
        group ?? '',
        courseName ?? '',
        duration ?? '',
        flashcardsType,
        areQuestionsAndAnswersSwapped,
      ];
}
