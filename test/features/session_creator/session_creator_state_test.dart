import 'package:flutter_test/flutter_test.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_bloc.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_mode.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/time_model.dart';

void main() {
  late SessionCreatorState state;

  setUp(
    () => state = const SessionCreatorState(
      status: BlocStatusInitial(),
      mode: SessionCreatorCreateMode(),
      courses: [],
      groups: null,
      selectedCourse: null,
      selectedGroup: null,
      flashcardsType: FlashcardsType.remembered,
      areQuestionsAndAnswersSwapped: false,
      date: null,
      startTime: null,
      duration: null,
      notificationTime: null,
    ),
  );

  test(
    'name for questions, should return name for questions from group if questions name and answers name are not swapped',
    () {
      state = state.copyWith(
        areQuestionsAndAnswersSwapped: false,
        selectedGroup: createGroup(
          nameForQuestions: 'questions',
          nameForAnswers: 'answers',
        ),
      );

      expect(state.nameForQuestions, 'questions');
    },
  );

  test(
    'name for questions, should return name for answers from group if questions name and answers name are swapped',
    () {
      state = state.copyWith(
        areQuestionsAndAnswersSwapped: true,
        selectedGroup: createGroup(
          nameForQuestions: 'questions',
          nameForAnswers: 'answers',
        ),
      );

      expect(state.nameForQuestions, 'answers');
    },
  );

  test(
    'name for answers, should return name for answers from group if questions name and answers name are not swapped',
    () {
      state = state.copyWith(
        areQuestionsAndAnswersSwapped: false,
        selectedGroup: createGroup(
          nameForQuestions: 'questions',
          nameForAnswers: 'answers',
        ),
      );

      expect(state.nameForAnswers, 'answers');
    },
  );

  test(
    'name for answers, should return name for questions from group if questions name and answers name are swapped',
    () {
      state = state.copyWith(
        areQuestionsAndAnswersSwapped: true,
        selectedGroup: createGroup(
          nameForQuestions: 'questions',
          nameForAnswers: 'answers',
        ),
      );

      expect(state.nameForAnswers, 'questions');
    },
  );

  test(
    'is button disabled, should be true if course has not been selected',
    () {
      state = state.copyWith(
        selectedGroup: createGroup(id: 'g1'),
        date: const Date(year: 2022, month: 1, day: 1),
        startTime: const Time(hour: 12, minute: 30),
      );

      expect(state.isButtonDisabled, true);
    },
  );

  test(
    'is button disabled, should be true if group has not been selected',
    () {
      state = state.copyWith(
        selectedCourse: createCourse(id: 'c1'),
        date: const Date(year: 2022, month: 1, day: 1),
        startTime: const Time(hour: 12, minute: 30),
      );

      expect(state.isButtonDisabled, true);
    },
  );

  test(
    'is button disabled, should be true if date has not been selected',
    () {
      state = state.copyWith(
        selectedCourse: createCourse(id: 'c1'),
        selectedGroup: createGroup(id: 'g1'),
        startTime: const Time(hour: 12, minute: 30),
      );

      expect(state.isButtonDisabled, true);
    },
  );

  test(
    'is button disabled, should be true if start time has not been selected',
    () {
      state = state.copyWith(
        selectedCourse: createCourse(id: 'c1'),
        selectedGroup: createGroup(id: 'g1'),
        date: const Date(year: 2022, month: 1, day: 1),
      );

      expect(state.isButtonDisabled, true);
    },
  );

  test(
    'is button disabled, edit mode, should be true if params have not been edited',
    () {
      final Session session = createSession(
        id: 's1',
        groupId: 'g1',
        flashcardsType: FlashcardsType.notRemembered,
        areQuestionsAndAnswersSwapped: false,
        date: const Date(year: 2022, month: 1, day: 1),
        startTime: const Time(hour: 12, minute: 20),
        duration: const Duration(minutes: 30),
        notificationTime: const Time(hour: 10, minute: 0),
      );
      state = state.copyWith(
        mode: SessionCreatorEditMode(session: session),
        selectedCourse: createCourse(id: 'c1'),
        selectedGroup: createGroup(id: 'g1'),
        flashcardsType: session.flashcardsType,
        areQuestionsAndAnswersSwapped: false,
        date: session.date,
        startTime: session.startTime,
        duration: session.duration,
        notificationTime: session.notificationTime,
      );

      expect(state.isButtonDisabled, true);
    },
  );

  test(
    'is button disabled, create mode, should be false if all required params have been selected',
    () {
      state = state.copyWith(
        selectedCourse: createCourse(id: 'c1'),
        selectedGroup: createGroup(id: 'g1'),
        date: const Date(year: 2022, month: 1, day: 1),
        startTime: const Time(hour: 12, minute: 50),
      );

      expect(state.isButtonDisabled, false);
    },
  );

  test(
    'is button disabled, edit mode, should be false if all required params have been selected and are different than original',
    () {
      final Session session = createSession(
        id: 's1',
        groupId: 'g1',
        flashcardsType: FlashcardsType.notRemembered,
        areQuestionsAndAnswersSwapped: false,
        date: const Date(year: 2022, month: 1, day: 1),
        startTime: const Time(hour: 12, minute: 20),
        duration: const Duration(minutes: 30),
        notificationTime: const Time(hour: 10, minute: 0),
      );
      state = state.copyWith(
        mode: SessionCreatorEditMode(session: session),
        selectedCourse: createCourse(id: 'c1'),
        selectedGroup: createGroup(id: 'g1'),
        flashcardsType: session.flashcardsType,
        areQuestionsAndAnswersSwapped: false,
        date: const Date(year: 2022, month: 1, day: 1),
        startTime: const Time(hour: 12, minute: 30),
        duration: session.duration,
        notificationTime: session.notificationTime,
      );

      expect(state.isButtonDisabled, false);
    },
  );

  test(
    'available flashcards types, should return all flashcards types if group has not been selected',
    () {
      expect(state.availableFlashcardsTypes, FlashcardsType.values);
    },
  );

  test(
    'available flashcards types, should return available flashcards types if group has been selected',
    () {
      final Group group = createGroup(
        flashcards: [
          createFlashcard(index: 0, status: FlashcardStatus.notRemembered),
          createFlashcard(index: 1, status: FlashcardStatus.notRemembered),
          createFlashcard(index: 2, status: FlashcardStatus.notRemembered),
        ],
      );

      state = state.copyWith(selectedGroup: group);

      expect(
        state.availableFlashcardsTypes,
        [FlashcardsType.all],
      );
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
      final SessionCreatorMode expectedMode = SessionCreatorEditMode(
        session: createSession(),
      );

      state = state.copyWith(mode: expectedMode);
      final state2 = state.copyWith();

      expect(state.mode, expectedMode);
      expect(state2.mode, expectedMode);
    },
  );

  test(
    'copy with courses',
    () {
      final List<Course> expectedCourses = [
        createCourse(id: 'c1', name: 'course 1'),
        createCourse(id: 'c2', name: 'course 2'),
      ];

      state = state.copyWith(courses: expectedCourses);
      final state2 = state.copyWith();

      expect(state.courses, expectedCourses);
      expect(state2.courses, expectedCourses);
    },
  );

  test(
    'copy with groups',
    () {
      final List<Group> expectedGroups = [
        createGroup(id: 'g1', name: 'group 1'),
        createGroup(id: 'g2', name: 'group 2'),
      ];

      state = state.copyWith(groups: expectedGroups);
      final state2 = state.copyWith();

      expect(state.groups, expectedGroups);
      expect(state2.groups, expectedGroups);
    },
  );

  test(
    'copy with selected course',
    () {
      final Course expectedCourse = createCourse(id: 'c1');

      state = state.copyWith(selectedCourse: expectedCourse);
      final state2 = state.copyWith();

      expect(state.selectedCourse, expectedCourse);
      expect(state2.selectedCourse, expectedCourse);
    },
  );

  test(
    'copy with selected group',
    () {
      final Group expectedGroup = createGroup(id: 'g1');

      state = state.copyWith(selectedGroup: expectedGroup);
      final state2 = state.copyWith();

      expect(state.selectedGroup, expectedGroup);
      expect(state2.selectedGroup, expectedGroup);
    },
  );

  test(
    'copy with flashcards type',
    () {
      const FlashcardsType expectedFlashcardsType = FlashcardsType.all;

      state = state.copyWith(flashcardsType: expectedFlashcardsType);
      final state2 = state.copyWith();

      expect(state.flashcardsType, expectedFlashcardsType);
      expect(state2.flashcardsType, expectedFlashcardsType);
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
    'copy with date',
    () {
      const Date expectedDate = Date(year: 2022, month: 1, day: 1);

      state = state.copyWith(date: expectedDate);
      final state2 = state.copyWith();

      expect(state.date, expectedDate);
      expect(state2.date, expectedDate);
    },
  );

  test(
    'copy with start time',
    () {
      const Time expectedTime = Time(hour: 12, minute: 30);

      state = state.copyWith(startTime: expectedTime);
      final state2 = state.copyWith();

      expect(state.startTime, expectedTime);
      expect(state2.startTime, expectedTime);
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
    'copy with notification time',
    () {
      const Time expectedTime = Time(hour: 10, minute: 0);

      state = state.copyWith(notificationTime: expectedTime);
      final state2 = state.copyWith();

      expect(state.notificationTime, expectedTime);
      expect(state2.notificationTime, expectedTime);
    },
  );

  test(
    'reset, should reset values marked as true',
    () {
      state = state.copyWith(
        selectedGroup: createGroup(id: 'g1'),
        duration: const Duration(minutes: 30),
        notificationTime: const Time(hour: 12, minute: 30),
      );

      final updatedState = state.reset(
        selectedGroup: true,
        duration: true,
        notificationTime: true,
      );

      expect(updatedState.selectedGroup, null);
      expect(updatedState.duration, null);
      expect(updatedState.notificationTime, null);
    },
  );

  test(
    'copy with info, should copy state with appropriate info type',
    () {
      const SessionCreatorInfo expectedInfo =
          SessionCreatorInfo.sessionHasBeenAdded;

      state = state.copyWithInfo(expectedInfo);

      expect(
        state.status,
        const BlocStatusComplete<SessionCreatorInfo>(info: expectedInfo),
      );
    },
  );
}
