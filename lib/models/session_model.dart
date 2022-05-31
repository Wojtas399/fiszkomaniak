import 'package:equatable/equatable.dart';
import 'time_model.dart';
import 'date_model.dart';

class Session extends Equatable {
  final String id;
  final String groupId;
  final FlashcardsType flashcardsType;
  final bool areQuestionsAndAnswersSwapped;
  final Date date;
  final Time time;
  final Duration? duration;
  final Time? notificationTime;

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

  Session copyWith({
    String? id,
    String? groupId,
    FlashcardsType? flashcardsType,
    bool? areQuestionsAndAnswersSwapped,
    Date? date,
    Time? time,
    Duration? duration,
    Time? notificationTime,
  }) {
    return Session(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      flashcardsType: flashcardsType ?? this.flashcardsType,
      areQuestionsAndAnswersSwapped:
          areQuestionsAndAnswersSwapped ?? this.areQuestionsAndAnswersSwapped,
      date: date ?? this.date,
      time: time ?? this.time,
      duration: duration ?? this.duration,
      notificationTime: notificationTime ?? this.notificationTime,
    );
  }
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
  Date? date,
  Time? time,
  Duration? duration,
  Time? notificationTime,
}) {
  return Session(
    id: id ?? '',
    groupId: groupId ?? '',
    flashcardsType: flashcardsType ?? FlashcardsType.all,
    areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped ?? false,
    date: date ?? const Date(year: 2022, month: 1, day: 1),
    time: time ?? const Time(hour: 1, minute: 1),
    duration: duration,
    notificationTime: notificationTime,
  );
}
