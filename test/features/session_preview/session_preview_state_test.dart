import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_mode.dart';
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
    expect(state.mode, null);
    expect(state.session, null);
    expect(state.group, null);
    expect(state.courseName, null);
    expect(state.duration, null);
    expect(state.flashcardsType, FlashcardsType.all);
    expect(state.areQuestionsAndAnswersSwapped, false);
  });

  test('copy with mode', () {
    final SessionPreviewMode mode = SessionPreviewModeNormal(sessionId: 's1');

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

  test('copy with duration', () {
    const TimeOfDay duration = TimeOfDay(hour: 0, minute: 30);

    final SessionPreviewState state2 = state.copyWith(duration: duration);
    final SessionPreviewState state3 = state2.copyWith();

    expect(state2.duration, duration);
    expect(state3.duration, null);
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

  test('date, normal mode', () {
    final SessionPreviewState updatedState = state.copyWith(
      mode: SessionPreviewModeNormal(sessionId: 's1'),
      session: createSession(id: 's1', date: DateTime(2022, 1, 1)),
    );

    expect(updatedState.date, DateTime(2022, 1, 1));
  });

  test('date, quick mode', () {
    final SessionPreviewState updatedState = state.copyWith(
      mode: SessionPreviewModeQuick(groupId: 'g1'),
    );

    expect(
      DateUtils.dateOnly(updatedState.date!),
      DateUtils.dateOnly(DateTime.now()),
    );
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
}
