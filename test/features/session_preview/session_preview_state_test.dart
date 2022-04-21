import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_state.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay subtractMinutes(int minutes) {
    return replacing(hour: hour, minute: minute - minutes);
  }
}

void main() {
  late SessionPreviewState state;

  setUp(() {
    state = const SessionPreviewState();
  });

  test('initial state', () {
    expect(state.mode, SessionMode.normal);
    expect(state.session, null);
    expect(state.group, null);
    expect(state.courseName, null);
    expect(state.time, null);
    expect(state.duration, null);
    expect(state.notificationTime, null);
    expect(state.flashcardsType, null);
    expect(state.areQuestionsAndAnswersSwapped, null);
  });

  test('copy with mode', () {
    const SessionMode mode = SessionMode.quick;

    final SessionPreviewState state2 = state.copyWith(mode: mode);
    final SessionPreviewState state3 = state2.copyWith();

    expect(state2.mode, mode);
    expect(state3.mode, mode);
  });

  test('copy with session', () {
    final Session session = createSession(id: 's1');

    final SessionPreviewState state2 = state.copyWith(session: session);
    final SessionPreviewState state3 = state2.copyWith();

    expect(state2.session, session);
    expect(state3.session, session);
  });

  test('copy with group', () {
    final Group group = createGroup(id: 'g1');

    final SessionPreviewState state2 = state.copyWith(group: group);
    final SessionPreviewState state3 = state2.copyWith();

    expect(state2.group, group);
    expect(state3.group, group);
  });

  test('copy with course name', () {
    const String courseName = 'course name';

    final SessionPreviewState state2 = state.copyWith(courseName: courseName);
    final SessionPreviewState state3 = state2.copyWith();

    expect(state2.courseName, courseName);
    expect(state3.courseName, courseName);
  });

  test('copy with time', () {
    const TimeOfDay time = TimeOfDay(hour: 12, minute: 30);

    final SessionPreviewState state2 = state.copyWith(time: time);
    final SessionPreviewState state3 = state2.copyWith();

    expect(state2.time, time);
    expect(state3.time, time);
  });

  test('copy with duration', () {
    const TimeOfDay duration = TimeOfDay(hour: 0, minute: 30);

    final SessionPreviewState state2 = state.copyWith(duration: duration);
    final SessionPreviewState state3 = state2.copyWith();

    expect(state2.duration, duration);
    expect(state3.duration, null);
  });

  test('copy with notification time', () {
    const TimeOfDay notificationTime = TimeOfDay(hour: 60, minute: 00);

    final SessionPreviewState state2 = state.copyWith(
      notificationTime: notificationTime,
    );
    final SessionPreviewState state3 = state2.copyWith();

    expect(state2.notificationTime, notificationTime);
    expect(state3.notificationTime, null);
  });

  test('copy with flashcards type', () {
    const FlashcardsType flashcardsType = FlashcardsType.remembered;

    final SessionPreviewState state2 = state.copyWith(
      flashcardsType: flashcardsType,
    );
    final SessionPreviewState state3 = state2.copyWith();

    expect(state2.flashcardsType, flashcardsType);
    expect(state3.flashcardsType, flashcardsType);
  });

  test('copy with are questions and answers swapped', () {
    const bool areQuestionsAndAnswersSwapped = true;

    final SessionPreviewState state2 = state.copyWith(
      areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
    );
    final SessionPreviewState state3 = state2.copyWith();

    expect(state2.areQuestionsAndAnswersSwapped, areQuestionsAndAnswersSwapped);
    expect(state3.areQuestionsAndAnswersSwapped, areQuestionsAndAnswersSwapped);
  });

  test('is overdue session, past day', () {
    final SessionPreviewState updatedState = state.copyWith(
      session: createSession(
        date: DateTime(2021, 1, 1),
        time: const TimeOfDay(hour: 12, minute: 0),
      ),
    );

    expect(updatedState.isOverdueSession, true);
  });

  test('is overdue session, today, past time', () {
    final SessionPreviewState updatedState = state.copyWith(
      session: createSession(
        date: DateTime.now(),
        time: TimeOfDay.now().subtractMinutes(1),
      ),
    );

    expect(updatedState.isOverdueSession, true);
  });

  test('is overdue session, future day', () {
    final SessionPreviewState updatedState = state.copyWith(
      session: createSession(
        date: DateUtils.addDaysToDate(DateTime.now(), 2),
        time: const TimeOfDay(hour: 12, minute: 0),
      ),
    );

    expect(updatedState.isOverdueSession, false);
  });

  group('name for questions and answers', () {
    final Group group = createGroup(
      id: 'g1',
      nameForQuestions: 'questions',
      nameForAnswers: 'answers',
    );

    test('normal order', () {
      final SessionPreviewState updatedState = state.copyWith(group: group);

      expect(updatedState.nameForQuestions, group.nameForQuestions);
      expect(updatedState.nameForAnswers, group.nameForAnswers);
    });

    test('reversed order', () {
      final Session session = createSession(
        id: 's1',
        areQuestionsAndAnswersSwapped: true,
      );

      final SessionPreviewState updatedState = state.copyWith(
        group: group,
        session: session,
        areQuestionsAndAnswersSwapped: session.areQuestionsAndAnswersSwapped,
      );

      expect(updatedState.nameForQuestions, group.nameForAnswers);
      expect(updatedState.nameForAnswers, group.nameForQuestions);
    });
  });

  test('have changes been made, false', () {
    final SessionPreviewState updatedState = state.copyWith(
      session: createSession(
        time: const TimeOfDay(hour: 12, minute: 30),
        duration: const TimeOfDay(hour: 0, minute: 30),
        notificationTime: const TimeOfDay(hour: 8, minute: 0),
        flashcardsType: FlashcardsType.remembered,
        areQuestionsAndAnswersSwapped: false,
      ),
      time: const TimeOfDay(hour: 12, minute: 30),
      duration: const TimeOfDay(hour: 0, minute: 30),
      notificationTime: const TimeOfDay(hour: 8, minute: 0),
      flashcardsType: FlashcardsType.remembered,
      areQuestionsAndAnswersSwapped: false,
    );

    expect(updatedState.haveChangesBeenMade, false);
  });

  test('have changes been made, true', () {
    final SessionPreviewState updatedState = state.copyWith(
      session: createSession(
        time: const TimeOfDay(hour: 12, minute: 30),
        duration: const TimeOfDay(hour: 0, minute: 30),
        notificationTime: const TimeOfDay(hour: 8, minute: 0),
        flashcardsType: FlashcardsType.remembered,
        areQuestionsAndAnswersSwapped: false,
      ),
      time: const TimeOfDay(hour: 12, minute: 30),
      duration: const TimeOfDay(hour: 1, minute: 30),
      notificationTime: const TimeOfDay(hour: 8, minute: 0),
      flashcardsType: FlashcardsType.notRemembered,
      areQuestionsAndAnswersSwapped: true,
    );

    expect(updatedState.haveChangesBeenMade, true);
  });
}
