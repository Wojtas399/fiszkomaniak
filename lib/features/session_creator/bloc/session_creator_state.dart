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
  final bool areQuestionsAndAnswersSwapped;
  final DateTime? date;
  final TimeOfDay? time;
  final TimeOfDay? duration;
  final TimeOfDay? notificationTime;

  String? get nameForQuestions => areQuestionsAndAnswersSwapped
      ? selectedGroup?.nameForAnswers
      : selectedGroup?.nameForQuestions;

  String? get nameForAnswers => areQuestionsAndAnswersSwapped
      ? selectedGroup?.nameForQuestions
      : selectedGroup?.nameForAnswers;

  bool get isButtonDisabled =>
      selectedCourse == null ||
      selectedGroup == null ||
      date == null ||
      time == null;

  const SessionCreatorState({
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
    List<Course>? courses,
    List<Group>? groups,
    Course? selectedCourse,
    Group? selectedGroup,
    FlashcardsType? flashcardsType,
    bool? areQuestionsAndAnswersSwapped,
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

  @override
  List<Object> get props => [
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
