import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_state.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SessionCreatorState state;
  final List<Course> courses = [
    createCourse(id: 'c1'),
    createCourse(id: 'c2'),
  ];
  final List<Group> groups = [
    createGroup(
      id: 'g1',
      nameForQuestions: 'questions',
      nameForAnswers: 'answers',
    ),
    createGroup(id: 'g2'),
    createGroup(id: 'g3'),
  ];

  setUp(() {
    state = const SessionCreatorState();
  });

  test('initial state', () {
    expect(state.courses, []);
    expect(state.groups, null);
    expect(state.selectedCourse, null);
    expect(state.selectedGroup, null);
    expect(state.flashcardsType, FlashcardsType.all);
    expect(state.areQuestionsAndAnswersSwapped, false);
    expect(state.date, null);
    expect(state.time, null);
    expect(state.duration, null);
    expect(state.notificationTime, null);
    expect(state.nameForQuestions, null);
    expect(state.nameForAnswers, null);
    expect(state.isButtonDisabled, true);
  });

  test('copy with courses', () {
    final SessionCreatorState state2 = state.copyWith(courses: courses);
    final SessionCreatorState state3 = state2.copyWith();

    expect(state2.courses, courses);
    expect(state3.courses, courses);
  });

  test('copy with groups', () {
    final SessionCreatorState state2 = state.copyWith(groups: groups);
    final SessionCreatorState state3 = state2.copyWith();

    expect(state2.groups, groups);
    expect(state3.groups, groups);
  });

  test('copy with selected course', () {
    final Course selectedCourse = courses[0];
    final SessionCreatorState state2 = state.copyWith(
      selectedCourse: selectedCourse,
    );
    final SessionCreatorState state3 = state2.copyWith();

    expect(state2.selectedCourse, selectedCourse);
    expect(state3.selectedCourse, selectedCourse);
  });

  test('copy with selected group', () {
    final Group selectedGroup = groups[0];
    final SessionCreatorState state2 = state.copyWith(selectedGroup: groups[0]);
    final SessionCreatorState state3 = state2.copyWith();

    expect(state2.selectedGroup, selectedGroup);
    expect(state3.selectedGroup, selectedGroup);
  });

  test('copy with flashcards type', () {
    const FlashcardsType flashcardsType = FlashcardsType.notRemembered;
    final SessionCreatorState state2 = state.copyWith(
      flashcardsType: flashcardsType,
    );
    final SessionCreatorState state3 = state2.copyWith();

    expect(state2.flashcardsType, flashcardsType);
    expect(state3.flashcardsType, flashcardsType);
  });

  test('copy with reversed questions with answers', () {
    const bool reversedQuestionsWithAnswers = true;
    final SessionCreatorState state2 = state.copyWith(
      areQuestionsAndAnswersSwapped: reversedQuestionsWithAnswers,
    );
    final SessionCreatorState state3 = state2.copyWith();

    expect(state2.areQuestionsAndAnswersSwapped, reversedQuestionsWithAnswers);
    expect(state3.areQuestionsAndAnswersSwapped, reversedQuestionsWithAnswers);
  });

  test('copy with date', () {
    final DateTime date = DateTime(2022);
    final SessionCreatorState state2 = state.copyWith(date: date);
    final SessionCreatorState state3 = state2.copyWith();

    expect(state2.date, date);
    expect(state3.date, date);
  });

  test('copy with time', () {
    const TimeOfDay time = TimeOfDay(hour: 18, minute: 0);
    final SessionCreatorState state2 = state.copyWith(time: time);
    final SessionCreatorState state3 = state2.copyWith();

    expect(state2.time, time);
    expect(state3.time, time);
  });

  test('copy with duration', () {
    const TimeOfDay duration = TimeOfDay(hour: 0, minute: 30);
    final SessionCreatorState state2 = state.copyWith(duration: duration);
    final SessionCreatorState state3 = state2.copyWith();

    expect(state2.duration, duration);
    expect(state3.duration, duration);
  });

  test('copy with notification time', () {
    const TimeOfDay notificationTime = TimeOfDay(hour: 12, minute: 30);
    final SessionCreatorState state2 = state.copyWith(
      notificationTime: notificationTime,
    );
    final SessionCreatorState state3 = state2.copyWith();

    expect(state2.notificationTime, notificationTime);
    expect(state3.notificationTime, notificationTime);
  });

  test('reset selected group', () {
    final Group selectedGroup = groups[0];
    final SessionCreatorState state2 = state.copyWith(
      selectedGroup: selectedGroup,
    );
    final SessionCreatorState state3 = state.reset(selectedGroup: true);

    expect(state2.selectedGroup, selectedGroup);
    expect(state3.selectedGroup, null);
  });

  test('reset notification time', () {
    const TimeOfDay notificationTime = TimeOfDay(hour: 12, minute: 30);
    final SessionCreatorState state2 = state.copyWith(
      notificationTime: notificationTime,
    );
    final SessionCreatorState state3 = state2.reset(notificationTime: true);

    expect(state2.notificationTime, notificationTime);
    expect(state3.notificationTime, null);
  });

  test('name for questions, normal', () {
    final Group group = groups[0];
    final SessionCreatorState updatedState = state.copyWith(
      selectedGroup: group,
    );

    expect(updatedState.nameForQuestions, group.nameForQuestions);
  });

  test('name for questions, questions and answers reversed', () {
    final Group group = groups[0];
    final SessionCreatorState updatedState = state.copyWith(
      selectedGroup: group,
      areQuestionsAndAnswersSwapped: true,
    );

    expect(updatedState.nameForQuestions, group.nameForAnswers);
  });

  test('name for answers, normal', () {
    final Group group = groups[0];
    final SessionCreatorState updatedState = state.copyWith(
      selectedGroup: group,
    );

    expect(updatedState.nameForAnswers, group.nameForAnswers);
  });

  test('name for answers, questions and answers reversed', () {
    final Group group = groups[0];
    final SessionCreatorState updatedState = state.copyWith(
      selectedGroup: group,
      areQuestionsAndAnswersSwapped: true,
    );

    expect(updatedState.nameForAnswers, group.nameForQuestions);
  });

  group('is button disabled', () {
    final Course selectedCourse = courses[0];
    final Group selectedGroup = groups[0];
    final DateTime date = DateTime(2022);
    const TimeOfDay time = TimeOfDay(hour: 18, minute: 0);
    const TimeOfDay duration = TimeOfDay(hour: 0, minute: 30);

    test('selected course as null', () {
      final SessionCreatorState updatedState = state.copyWith(
        selectedGroup: selectedGroup,
        date: date,
        time: time,
        duration: duration,
      );

      expect(updatedState.isButtonDisabled, true);
    });

    test('selected group as null', () {
      final SessionCreatorState updatedState = state.copyWith(
        selectedCourse: selectedCourse,
        date: date,
        time: time,
        duration: duration,
      );

      expect(updatedState.isButtonDisabled, true);
    });

    test('date as null', () {
      final SessionCreatorState updatedState = state.copyWith(
        selectedCourse: selectedCourse,
        selectedGroup: selectedGroup,
        time: time,
        duration: duration,
      );

      expect(updatedState.isButtonDisabled, true);
    });

    test('time as null', () {
      final SessionCreatorState updatedState = state.copyWith(
        selectedCourse: selectedCourse,
        selectedGroup: selectedGroup,
        date: date,
        duration: duration,
      );

      expect(updatedState.isButtonDisabled, true);
    });

    test('duration as null', () {
      final SessionCreatorState updatedState = state.copyWith(
        selectedCourse: selectedCourse,
        selectedGroup: selectedGroup,
        date: date,
        time: time,
      );

      expect(updatedState.isButtonDisabled, true);
    });

    test('nothing as null', () {
      final SessionCreatorState updatedState = state.copyWith(
        selectedCourse: selectedCourse,
        selectedGroup: selectedGroup,
        date: date,
        time: time,
        duration: duration,
      );

      expect(updatedState.isButtonDisabled, false);
    });
  });
}
