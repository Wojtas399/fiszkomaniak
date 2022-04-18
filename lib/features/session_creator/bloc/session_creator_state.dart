import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter/material.dart';
import '../../../models/session_model.dart';

class SessionCreatorState extends Equatable {
  final List<Course> courses;
  final List<Group>? groups;
  final Course? selectedCourse;
  final Group? selectedGroup;
  final FlashcardsType flashcardsType;
  final bool reversedQuestionsWithAnswers;
  final DateTime? date;
  final TimeOfDay? time;
  final TimeOfDay? duration;
  final TimeOfDay? notificationTime;

  String? get nameForQuestions => reversedQuestionsWithAnswers
      ? selectedGroup?.nameForAnswers
      : selectedGroup?.nameForQuestions;

  String? get nameForAnswers => reversedQuestionsWithAnswers
      ? selectedGroup?.nameForQuestions
      : selectedGroup?.nameForAnswers;

  bool get isButtonDisabled =>
      selectedCourse == null ||
      selectedGroup == null ||
      date == null ||
      time == null ||
      duration == null;

  const SessionCreatorState({
    this.courses = const [],
    this.groups,
    this.selectedCourse,
    this.selectedGroup,
    this.flashcardsType = FlashcardsType.all,
    this.reversedQuestionsWithAnswers = false,
    this.date,
    this.time,
    this.duration,
    this.notificationTime,
  });

  SessionCreatorState copyWith({
    List<Course>? courses,
    List<Group>? groups,
    Course? selectedCourse,
    Group? selectedGroup,
    FlashcardsType? flashcardsType,
    bool? reversedQuestionsWithAnswers,
    DateTime? date,
    TimeOfDay? time,
    TimeOfDay? duration,
    TimeOfDay? notificationTime,
  }) {
    return SessionCreatorState(
      courses: courses ?? this.courses,
      groups: groups ?? this.groups,
      selectedCourse: selectedCourse ?? this.selectedCourse,
      selectedGroup: selectedGroup ?? this.selectedGroup,
      flashcardsType: flashcardsType ?? this.flashcardsType,
      reversedQuestionsWithAnswers:
          reversedQuestionsWithAnswers ?? this.reversedQuestionsWithAnswers,
      date: date ?? this.date,
      time: time ?? this.time,
      duration: duration ?? this.duration,
      notificationTime: notificationTime ?? this.notificationTime,
    );
  }

  SessionCreatorState reset({
    bool selectedGroup = false,
    bool notificationTime = false,
  }) {
    return SessionCreatorState(
      courses: courses,
      groups: groups,
      selectedCourse: selectedCourse,
      selectedGroup: selectedGroup ? null : this.selectedGroup,
      flashcardsType: flashcardsType,
      reversedQuestionsWithAnswers: reversedQuestionsWithAnswers,
      date: date,
      time: time,
      duration: duration,
      notificationTime: notificationTime ? null : this.notificationTime,
    );
  }

  @override
  List<Object> get props => [
        courses,
        groups ?? [],
        selectedCourse ?? createCourse(),
        selectedGroup ?? createGroup(),
        flashcardsType,
        reversedQuestionsWithAnswers,
        date ?? '',
        time ?? '',
        duration ?? '',
        notificationTime ?? '',
      ];
}
