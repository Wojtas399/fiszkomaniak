import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Session extends Equatable {
  final String id;
  final String groupId;
  final FlashcardsType flashcardsType;
  final bool areQuestionsAndAnswersSwapped;
  final DateTime date;
  final TimeOfDay time;
  final Duration? duration;
  final TimeOfDay? notificationTime;

  const Session({
    required this.id,
    required this.groupId,
    required this.flashcardsType,
    required this.areQuestionsAndAnswersSwapped,
    required this.date,
    required this.time,
    required this.duration,
    required this.notificationTime,
  });

  @override
  List<Object> get props => [
        id,
        groupId,
        flashcardsType,
        areQuestionsAndAnswersSwapped,
        date,
        time,
        duration ?? '',
        notificationTime ?? '',
      ];
}

enum FlashcardsType {
  all,
  remembered,
  notRemembered,
}

Session createSession({
  String? id,
  String? groupId,
  FlashcardsType? flashcardsType,
  bool? areQuestionsAndAnswersSwapped,
  DateTime? date,
  TimeOfDay? time,
  Duration? duration,
  TimeOfDay? notificationTime,
}) {
  return Session(
    id: id ?? '',
    groupId: groupId ?? '',
    flashcardsType: flashcardsType ?? FlashcardsType.all,
    areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped ?? false,
    date: date ?? DateTime(2022),
    time: time ?? const TimeOfDay(hour: 12, minute: 0),
    duration: duration,
    notificationTime: notificationTime,
  );
}
