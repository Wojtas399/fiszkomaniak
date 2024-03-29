part of 'session_preview_bloc.dart';

class SessionPreviewState extends Equatable {
  final BlocStatus status;
  final SessionPreviewMode? mode;
  final Session? session;
  final Group? group;
  final String? courseName;
  final Duration? duration;
  final FlashcardsType flashcardsType;
  final bool areQuestionsAndAnswersSwapped;

  const SessionPreviewState({
    required this.status,
    required this.mode,
    required this.session,
    required this.group,
    required this.courseName,
    required this.duration,
    required this.flashcardsType,
    required this.areQuestionsAndAnswersSwapped,
  });

  @override
  List<Object> get props => [
        status,
        mode ?? '',
        session ?? '',
        group ?? '',
        courseName ?? '',
        duration ?? '',
        flashcardsType,
        areQuestionsAndAnswersSwapped,
      ];

  Date? get date {
    if (mode is SessionPreviewModeNormal) {
      return session?.date;
    } else if (mode is SessionPreviewModeQuick) {
      return Date.now();
    }
    return null;
  }

  String? get nameForQuestions => areQuestionsAndAnswersSwapped == true
      ? group?.nameForAnswers
      : group?.nameForQuestions;

  String? get nameForAnswers => areQuestionsAndAnswersSwapped == true
      ? group?.nameForQuestions
      : group?.nameForAnswers;

  List<FlashcardsType> get availableFlashcardsTypes {
    final Group? group = this.group;
    if (group == null) {
      return FlashcardsType.values;
    }
    return GroupsUtils.getAvailableFlashcardsTypes(group);
  }

  SessionPreviewState copyWith({
    BlocStatus? status,
    SessionPreviewMode? mode,
    Session? session,
    Group? group,
    String? courseName,
    Duration? duration,
    FlashcardsType? flashcardsType,
    bool? areQuestionsAndAnswersSwapped,
    bool durationAsNull = false,
  }) {
    return SessionPreviewState(
      status: status ?? const BlocStatusInProgress(),
      mode: mode ?? this.mode,
      session: session ?? this.session,
      group: group ?? this.group,
      courseName: courseName ?? this.courseName,
      duration: durationAsNull ? null : duration ?? this.duration,
      flashcardsType: flashcardsType ?? this.flashcardsType,
      areQuestionsAndAnswersSwapped:
          areQuestionsAndAnswersSwapped ?? this.areQuestionsAndAnswersSwapped,
    );
  }

  SessionPreviewState copyWithInfo(SessionPreviewInfo info) {
    return copyWith(
      status: BlocStatusComplete<SessionPreviewInfo>(info: info),
    );
  }
}

enum SessionPreviewInfo {
  sessionHasBeenDeleted,
}
