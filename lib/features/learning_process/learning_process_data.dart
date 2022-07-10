import 'package:equatable/equatable.dart';
import '../../domain/entities/session.dart';

class LearningProcessData extends Equatable {
  final String? sessionId;
  final String groupId;
  final Duration? duration;
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
  Duration? duration,
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
