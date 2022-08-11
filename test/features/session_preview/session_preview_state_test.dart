import 'package:flutter_test/flutter_test.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_bloc.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_mode.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:fiszkomaniak/models/date_model.dart';

void main() {
  late SessionPreviewState state;

  setUp(
    () => state = const SessionPreviewState(
      status: BlocStatusInitial(),
      mode: null,
      session: null,
      group: null,
      courseName: null,
      duration: null,
      flashcardsType: FlashcardsType.all,
      areQuestionsAndAnswersSwapped: false,
    ),
  );

  test(
    'date, mode normal, should return date from session',
    () {
      final Session session = createSession(
        id: 's1',
        date: const Date(year: 2022, month: 1, day: 1),
      );

      state = state.copyWith(
        mode: SessionPreviewModeNormal(sessionId: session.id),
        session: session,
      );

      expect(state.date, session.date);
    },
  );

  test(
    'date, mode quick, should return date now',
    () {
      state = state.copyWith(
        mode: SessionPreviewModeQuick(groupId: 'g1'),
      );

      expect(state.date, Date.now());
    },
  );

  group(
    'name for questions and name for answers',
    () {
      final Group group = createGroup(
        nameForQuestions: 'questions',
        nameForAnswers: 'answers',
      );

      test(
        'name for questions should return name for questions if questions name is not swapped with answers name',
        () {
          state = state.copyWith(
            group: group,
            areQuestionsAndAnswersSwapped: false,
          );

          expect(state.nameForQuestions, group.nameForQuestions);
        },
      );

      test(
        'name for questions should return name for answers if questions name is swapped with answers name',
        () {
          state = state.copyWith(
            group: group,
            areQuestionsAndAnswersSwapped: true,
          );

          expect(state.nameForQuestions, group.nameForAnswers);
        },
      );

      test(
        'name for answers should return name for answers if answers name is not swapped with questions name',
        () {
          state = state.copyWith(
            group: group,
            areQuestionsAndAnswersSwapped: false,
          );

          expect(state.nameForAnswers, group.nameForAnswers);
        },
      );

      test(
        'name for answers should return name for questions if answers name is swapped with questions name',
        () {
          state = state.copyWith(
            group: group,
            areQuestionsAndAnswersSwapped: true,
          );

          expect(state.nameForAnswers, group.nameForQuestions);
        },
      );
    },
  );

  test(
    'available flashcards types should return all flashcards types if group has not been set',
    () {
      expect(state.availableFlashcardsTypes, FlashcardsType.values);
    },
  );

  test(
    'available flashcards types should return available flashcards types if group has been set',
    () {
      final Group group = createGroup(
        id: 'g1',
        flashcards: [
          createFlashcard(status: FlashcardStatus.remembered),
          createFlashcard(status: FlashcardStatus.remembered),
        ],
      );

      state = state.copyWith(group: group);

      expect(state.availableFlashcardsTypes, [FlashcardsType.all]);
    },
  );

  test(
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusInProgress());
    },
  );

  test(
    'copy with mode',
    () {
      final SessionPreviewMode expectedMode = SessionPreviewModeQuick(
        groupId: 'g1',
      );

      state = state.copyWith(mode: expectedMode);
      final state2 = state.copyWith();

      expect(state.mode, expectedMode);
      expect(state2.mode, expectedMode);
    },
  );

  test(
    'copy with session',
    () {
      final Session expectedSession = createSession(id: 's1');

      state = state.copyWith(session: expectedSession);
      final state2 = state.copyWith();

      expect(state.session, expectedSession);
      expect(state2.session, expectedSession);
    },
  );

  test(
    'copy with group',
    () {
      final Group expectedGroup = createGroup(id: 'g1');

      state = state.copyWith(group: expectedGroup);
      final state2 = state.copyWith();

      expect(state.group, expectedGroup);
      expect(state2.group, expectedGroup);
    },
  );

  test(
    'copy with course name',
    () {
      const String expectedName = 'course name';

      state = state.copyWith(courseName: expectedName);
      final state2 = state.copyWith();

      expect(state.courseName, expectedName);
      expect(state2.courseName, expectedName);
    },
  );

  test(
    'copy with duration',
    () {
      const Duration expectedDuration = Duration(minutes: 30);

      state = state.copyWith(duration: expectedDuration);
      final state2 = state.copyWith();

      expect(state.duration, expectedDuration);
      expect(state2.duration, expectedDuration);
    },
  );

  test(
    'copy with flashcards type',
    () {
      const FlashcardsType expectedType = FlashcardsType.remembered;

      state = state.copyWith(flashcardsType: expectedType);
      final state2 = state.copyWith();

      expect(state.flashcardsType, expectedType);
      expect(state2.flashcardsType, expectedType);
    },
  );

  test(
    'copy with are questions and answers swapped',
    () {
      const bool expectedValue = true;

      state = state.copyWith(areQuestionsAndAnswersSwapped: expectedValue);
      final state2 = state.copyWith();

      expect(state.areQuestionsAndAnswersSwapped, expectedValue);
      expect(state2.areQuestionsAndAnswersSwapped, expectedValue);
    },
  );

  test(
    'copy with duration as null',
    () {
      const Duration duration = Duration(minutes: 30);

      state = state.copyWith(duration: duration);
      final state2 = state.copyWith(durationAsNull: true);

      expect(state.duration, duration);
      expect(state2.duration, null);
    },
  );

  test(
    'copy with info',
    () {
      const SessionPreviewInfo expectedInfo =
          SessionPreviewInfo.sessionHasBeenDeleted;

      state = state.copyWithInfo(expectedInfo);

      expect(
        state.status,
        const BlocStatusComplete<SessionPreviewInfo>(info: expectedInfo),
      );
    },
  );
}
