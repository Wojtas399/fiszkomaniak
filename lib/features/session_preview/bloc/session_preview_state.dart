import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:fiszkomaniak/utils/date_utils.dart' as custom_date_utils;
import 'package:flutter/material.dart';
import '../../../models/group_model.dart';

class SessionPreviewState extends Equatable {
  final SessionMode mode;
  final Session? session;
  final Group? group;
  final String? courseName;
  final TimeOfDay? time;
  final TimeOfDay? duration;
  final TimeOfDay? notificationTime;
  final FlashcardsType? flashcardsType;
  final bool? areQuestionsAndAnswersSwapped;

  const SessionPreviewState({
    this.mode = SessionMode.normal,
    this.session,
    this.group,
    this.courseName,
    this.time,
    this.duration,
    this.notificationTime,
    this.flashcardsType,
    this.areQuestionsAndAnswersSwapped,
  });

  bool get isOverdueSession {
    final DateTime? date = session?.date;
    final TimeOfDay? time = session?.time;
    if (date != null && time != null) {
      final int dateComparison = custom_date_utils.DateUtils.compareDates(
        DateTime.now(),
        date,
      );
      final int timeComparison = custom_date_utils.DateUtils.compareTimes(
        TimeOfDay.now(),
        time,
      );
      if (dateComparison == 0) {
        return timeComparison == 1;
      } else {
        return dateComparison == 1;
      }
    }
    return false;
  }

  String? get nameForQuestions => areQuestionsAndAnswersSwapped == true
      ? group?.nameForAnswers
      : group?.nameForQuestions;

  String? get nameForAnswers => areQuestionsAndAnswersSwapped == true
      ? group?.nameForQuestions
      : group?.nameForAnswers;

  bool get haveChangesBeenMade =>
      time != session?.time ||
      duration != session?.duration ||
      notificationTime != session?.notificationTime ||
      flashcardsType != session?.flashcardsType ||
      areQuestionsAndAnswersSwapped != session?.areQuestionsAndAnswersSwapped;

  SessionPreviewState copyWith({
    SessionMode? mode,
    Session? session,
    Group? group,
    String? courseName,
    TimeOfDay? time,
    TimeOfDay? duration,
    TimeOfDay? notificationTime,
    FlashcardsType? flashcardsType,
    bool? areQuestionsAndAnswersSwapped,
  }) {
    return SessionPreviewState(
      mode: mode ?? this.mode,
      session: session ?? this.session,
      group: group ?? this.group,
      courseName: courseName ?? this.courseName,
      time: time ?? this.time,
      duration: duration,
      notificationTime: notificationTime,
      flashcardsType: flashcardsType ?? this.flashcardsType,
      areQuestionsAndAnswersSwapped:
          areQuestionsAndAnswersSwapped ?? this.areQuestionsAndAnswersSwapped,
    );
  }

  @override
  List<Object> get props => [
        mode,
        session ?? createSession(),
        group ?? createGroup(),
        courseName ?? '',
        time ?? const TimeOfDay(hour: 0, minute: 0),
        duration ?? const TimeOfDay(hour: 0, minute: 0),
        notificationTime ?? const TimeOfDay(hour: 0, minute: 0),
        flashcardsType ?? FlashcardsType.all,
        areQuestionsAndAnswersSwapped ?? false,
      ];
}

enum SessionMode {
  normal,
  quick,
}
