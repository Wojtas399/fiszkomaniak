part of 'session_creator_bloc.dart';

class SessionCreatorState extends Equatable {
  final BlocStatus status;
  final SessionCreatorMode mode;
  final List<Course> courses;
  final List<Group>? groups;
  final Course? selectedCourse;
  final Group? selectedGroup;
  final FlashcardsType flashcardsType;
  final bool areQuestionsAndAnswersSwapped;
  final Date? date;
  final Time? startTime;
  final Duration? duration;
  final Time? notificationTime;

  const SessionCreatorState({
    required this.status,
    required this.mode,
    required this.courses,
    required this.groups,
    required this.selectedCourse,
    required this.selectedGroup,
    required this.flashcardsType,
    required this.areQuestionsAndAnswersSwapped,
    required this.date,
    required this.startTime,
    required this.duration,
    required this.notificationTime,
  });

  @override
  List<Object> get props => [
        status,
        mode,
        courses,
        groups ?? [],
        selectedCourse ?? createCourse(),
        selectedGroup ?? createGroup(),
        flashcardsType,
        areQuestionsAndAnswersSwapped,
        date ?? '',
        startTime ?? '',
        duration ?? '',
        notificationTime ?? '',
      ];

  String? get nameForQuestions => areQuestionsAndAnswersSwapped
      ? selectedGroup?.nameForAnswers
      : selectedGroup?.nameForQuestions;

  String? get nameForAnswers => areQuestionsAndAnswersSwapped
      ? selectedGroup?.nameForQuestions
      : selectedGroup?.nameForAnswers;

  bool get isButtonDisabled =>
      _isOneOfRequiredParamsNull() || _areParamsSameAsOriginal();

  List<FlashcardsType> get availableFlashcardsTypes {
    final Group? group = selectedGroup;
    if (group == null) {
      return FlashcardsType.values;
    }
    return GroupUtils.getAvailableFlashcardsTypes(group);
  }

  SessionCreatorState copyWith({
    BlocStatus? status,
    SessionCreatorMode? mode,
    List<Course>? courses,
    List<Group>? groups,
    Course? selectedCourse,
    Group? selectedGroup,
    FlashcardsType? flashcardsType,
    bool? areQuestionsAndAnswersSwapped,
    Date? date,
    Time? startTime,
    Duration? duration,
    Time? notificationTime,
  }) {
    return SessionCreatorState(
      status: status ?? const BlocStatusInProgress(),
      mode: mode ?? this.mode,
      courses: courses ?? this.courses,
      groups: groups ?? this.groups,
      selectedCourse: selectedCourse ?? this.selectedCourse,
      selectedGroup: selectedGroup ?? this.selectedGroup,
      flashcardsType: flashcardsType ?? this.flashcardsType,
      areQuestionsAndAnswersSwapped:
          areQuestionsAndAnswersSwapped ?? this.areQuestionsAndAnswersSwapped,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration,
      notificationTime: notificationTime ?? this.notificationTime,
    );
  }

  SessionCreatorState reset({
    bool selectedGroup = false,
    bool duration = false,
    bool notificationTime = false,
  }) {
    return SessionCreatorState(
      status: const BlocStatusInProgress(),
      mode: mode,
      courses: courses,
      groups: groups,
      selectedCourse: selectedCourse,
      selectedGroup: selectedGroup ? null : this.selectedGroup,
      flashcardsType: flashcardsType,
      areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
      date: date,
      startTime: startTime,
      duration: duration ? null : this.duration,
      notificationTime: notificationTime ? null : this.notificationTime,
    );
  }

  SessionCreatorState copyWithInfo(SessionCreatorInfo info) {
    return copyWith(
      status: BlocStatusComplete<SessionCreatorInfo>(info: info),
    );
  }

  bool _isOneOfRequiredParamsNull() {
    return selectedCourse == null ||
        selectedGroup == null ||
        date == null ||
        startTime == null;
  }

  bool _areParamsSameAsOriginal() {
    final SessionCreatorMode mode = this.mode;
    if (mode is SessionCreatorEditMode) {
      final Session session = mode.session;
      return selectedGroup?.id == session.groupId &&
          flashcardsType == session.flashcardsType &&
          areQuestionsAndAnswersSwapped ==
              session.areQuestionsAndAnswersSwapped &&
          date == session.date &&
          startTime == session.startTime &&
          duration == session.duration &&
          notificationTime == session.notificationTime;
    } else {
      return false;
    }
  }
}

enum SessionCreatorInfo {
  timeFromThePast,
  chosenStartTimeIsEarlierThanNotificationTime,
  chosenNotificationTimeIsLaterThanStartTime,
  sessionHasBeenAdded,
  sessionHasBeenUpdated,
}
