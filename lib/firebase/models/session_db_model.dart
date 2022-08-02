import 'package:equatable/equatable.dart';

class SessionDbModel extends Equatable {
  final String? groupId;
  final String? flashcardsType;
  final bool? areQuestionsAndAnswersSwapped;
  final String? date;
  final String? time;
  final String? duration;
  final String? notificationTime;

  const SessionDbModel({
    required this.groupId,
    required this.flashcardsType,
    required this.areQuestionsAndAnswersSwapped,
    required this.date,
    required this.time,
    required this.duration,
    required this.notificationTime,
  });

  SessionDbModel.fromJson(Map<String, Object?> json)
      : this(
          groupId: json['groupId']! as String,
          flashcardsType: json['flashcardsType']! as String,
          areQuestionsAndAnswersSwapped:
              json['areQuestionsAndAnswersSwapped'] as bool,
          date: json['date']! as String,
          time: json['time']! as String,
          duration: json['duration'] as String?,
          notificationTime: json['notificationTime'] as String?,
        );

  Map<String, Object?> toJson() {
    return {
      'groupId': groupId,
      'flashcardsType': flashcardsType,
      'areQuestionsAndAnswersSwapped': areQuestionsAndAnswersSwapped,
      'date': date,
      'time': time,
      'duration': duration,
      'notificationTime': notificationTime,
    };
  }

  @override
  List<Object> get props => [
        groupId ?? '',
        flashcardsType ?? '',
        areQuestionsAndAnswersSwapped ?? '',
        date ?? '',
        time ?? '',
        duration ?? '',
        notificationTime ?? '',
      ];
}

SessionDbModel createSessionDbModel({
  String groupId = '',
  String flashcardsType = '',
  bool areQuestionsAndAnswersSwapped = false,
  String date = '',
  String time = '',
  String? duration,
  String? notificationTime,
}) {
  return SessionDbModel(
    groupId: groupId,
    flashcardsType: flashcardsType,
    areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
    date: date,
    time: time,
    duration: duration,
    notificationTime: notificationTime,
  );
}
