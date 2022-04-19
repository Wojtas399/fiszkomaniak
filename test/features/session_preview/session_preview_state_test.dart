import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_state.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SessionPreviewState state;

  setUp(() {
    state = const SessionPreviewState();
  });

  test('initial state', () {
    expect(state.session, null);
    expect(state.group, null);
    expect(state.courseName, null);
    expect(state.nameForQuestions, null);
    expect(state.nameForAnswers, null);
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
      );

      expect(updatedState.nameForQuestions, group.nameForAnswers);
      expect(updatedState.nameForAnswers, group.nameForQuestions);
    });
  });
}
