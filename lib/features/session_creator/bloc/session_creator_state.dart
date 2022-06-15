part of 'session_creator_bloc.dart';

class SessionCreatorState extends Equatable {
  final SessionCreatorMode mode;
  final SessionCreatorStatus status;
  final List<Course> courses;
  final List<Group>? groups;
  final Course? selectedCourse;
  final Group? selectedGroup;
  final FlashcardsType flashcardsType;
  final bool areQuestionsAndAnswersSwapped;
  final Date? date;
  final Time? time;
  final Duration? duration;
  final Time? notificationTime;

  const SessionCreatorState({
    this.mode = const SessionCreatorCreateMode(),
    this.status = const SessionCreatorStatusInitial(),
    this.courses = const [],
    this.groups,
    this.selectedCourse,
    this.selectedGroup,
    this.flashcardsType = FlashcardsType.all,
    this.areQuestionsAndAnswersSwapped = false,
    this.date,
    this.time,
    this.duration,
    this.notificationTime,
  });

  @override
  List<Object> get props => [
        mode,
        status,
        courses,
        groups ?? [],
        selectedCourse ?? createCourse(),
        selectedGroup ?? createGroup(),
        flashcardsType,
        areQuestionsAndAnswersSwapped,
        date ?? '',
        time ?? '',
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
    SessionCreatorMode? mode,
    SessionCreatorStatus? status,
    List<Course>? courses,
    List<Group>? groups,
    Course? selectedCourse,
    Group? selectedGroup,
    FlashcardsType? flashcardsType,
    bool? areQuestionsAndAnswersSwapped,
    Date? date,
    Time? time,
    Duration? duration,
    Time? notificationTime,
  }) {
    return SessionCreatorState(
      mode: mode ?? this.mode,
      status: status ?? SessionCreatorStatusLoaded(),
      courses: courses ?? this.courses,
      groups: groups ?? this.groups,
      selectedCourse: selectedCourse ?? this.selectedCourse,
      selectedGroup: selectedGroup ?? this.selectedGroup,
      flashcardsType: flashcardsType ?? this.flashcardsType,
      areQuestionsAndAnswersSwapped:
          areQuestionsAndAnswersSwapped ?? this.areQuestionsAndAnswersSwapped,
      date: date ?? this.date,
      time: time ?? this.time,
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
      mode: mode,
      status: status,
      courses: courses,
      groups: groups,
      selectedCourse: selectedCourse,
      selectedGroup: selectedGroup ? null : this.selectedGroup,
      flashcardsType: flashcardsType,
      areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
      date: date,
      time: time,
      duration: duration ? null : this.duration,
      notificationTime: notificationTime ? null : this.notificationTime,
    );
  }

  bool _isOneOfRequiredParamsNull() {
    return selectedCourse == null ||
        selectedGroup == null ||
        date == null ||
        time == null;
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
          time == session.time &&
          duration == session.duration &&
          notificationTime == session.notificationTime;
    } else {
      return false;
    }
  }
}
