import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_mode.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:fiszkomaniak/utils/group_utils.dart';
import 'package:flutter/material.dart';
import '../../../models/session_model.dart';

class SessionCreatorState extends Equatable {
  final SessionCreatorMode mode;
  final List<Course> courses;
  final List<Group>? groups;
  final Course? selectedCourse;
  final Group? selectedGroup;
  final FlashcardsType flashcardsType;
  final bool areQuestionsAndAnswersSwapped;
  final DateTime? date;
  final TimeOfDay? time;
  final Duration? duration;
  final TimeOfDay? notificationTime;

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
    return GroupUtils.getAvailableFlashcardsTypeFromGroup(group);
  }

  const SessionCreatorState({
    this.mode = const SessionCreatorCreateMode(),
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

  SessionCreatorState copyWith({
    SessionCreatorMode? mode,
    List<Course>? courses,
    List<Group>? groups,
    Course? selectedCourse,
    Group? selectedGroup,
    FlashcardsType? flashcardsType,
    bool? areQuestionsAndAnswersSwapped,
    DateTime? date,
    TimeOfDay? time,
    Duration? duration,
    TimeOfDay? notificationTime,
  }) {
    return SessionCreatorState(
      mode: mode ?? this.mode,
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

  @override
  List<Object> get props => [
        mode,
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
}
