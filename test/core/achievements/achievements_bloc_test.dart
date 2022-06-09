import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/achievements/achievements_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/user/user_bloc.dart';
import 'package:fiszkomaniak/interfaces/achievements_interface.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/day_model.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:fiszkomaniak/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAchievementsInterface extends Mock implements AchievementsInterface {}

class MockUserBloc extends Mock implements UserBloc {}

class MockFlashcardsBloc extends Mock implements FlashcardsBloc {}

void main() {
  final AchievementsInterface achievementsInterface =
      MockAchievementsInterface();
  final UserBloc userBloc = MockUserBloc();
  final FlashcardsBloc flashcardsBloc = MockFlashcardsBloc();
  late AchievementsBloc bloc;
  final FlashcardsState flashcardsState = FlashcardsState(
    groupsState: GroupsState(
      allGroups: [
        createGroup(flashcards: [createFlashcard(), createFlashcard()]),
        createGroup(flashcards: [createFlashcard()]),
      ],
    ),
  );

  setUp(() {
    bloc = AchievementsBloc(
      achievementsInterface: achievementsInterface,
      userBloc: userBloc,
      flashcardsBloc: flashcardsBloc,
    );
    when(() => flashcardsBloc.state).thenReturn(flashcardsState);
    when(() => userBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => flashcardsBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  tearDown(() {
    reset(achievementsInterface);
    reset(userBloc);
    reset(flashcardsBloc);
  });

  blocTest(
    'initialize, user does not exist',
    build: () => bloc,
    setUp: () {
      when(() => userBloc.state).thenReturn(const UserState());
    },
    act: (_) => bloc.add(AchievementsEventInitialize()),
    expect: () => [
      AchievementsState(
        status: AchievementsStatusLoaded(),
        daysStreak: 0,
        allFlashcardsAmount: 3,
      ),
    ],
  );

  blocTest(
    'initialize, user exists',
    build: () => bloc,
    setUp: () {
      when(() => userBloc.state).thenReturn(UserState(
        loggedUser: createUser(days: [
          createDay(date: Date.now()),
          createDay(date: Date.now().subtractDays(2)),
          createDay(date: Date.now().subtractDays(1)),
        ]),
      ));
    },
    act: (_) => bloc.add(AchievementsEventInitialize()),
    expect: () => [
      AchievementsState(
        status: AchievementsStatusLoaded(),
        daysStreak: 3,
        allFlashcardsAmount: 3,
      ),
    ],
  );

  blocTest(
    'user state updated, days streak has been set to 1',
    build: () => bloc,
    setUp: () {
      when(() => userBloc.stream).thenAnswer(
        (_) => Stream.value(UserState(
          loggedUser: createUser(
            days: [createDay(date: Date.now())],
          ),
        )),
      );
      when(() => userBloc.state).thenReturn(UserState(
        loggedUser: createUser(days: []),
      ));
    },
    act: (_) => bloc.add(AchievementsEventInitialize()),
    expect: () => [
      AchievementsState(
        status: AchievementsStatusLoaded(),
        daysStreak: 0,
        allFlashcardsAmount: 3,
      ),
      AchievementsState(
        status: AchievementsStatusLoaded(),
        daysStreak: 1,
        allFlashcardsAmount: 3,
      ),
    ],
  );

  blocTest(
    'user state updated, days streak increased',
    build: () => bloc,
    setUp: () {
      when(() => userBloc.stream).thenAnswer(
        (_) => Stream.value(UserState(
          loggedUser: createUser(days: [
            createDay(date: Date.now()),
            createDay(date: Date.now().subtractDays(2)),
            createDay(date: Date.now().subtractDays(1)),
            createDay(date: Date.now().subtractDays(3)),
          ]),
        )),
      );
      when(() => userBloc.state).thenReturn(UserState(
        loggedUser: createUser(days: [
          createDay(date: Date.now()),
          createDay(date: Date.now().subtractDays(2)),
          createDay(date: Date.now().subtractDays(1)),
        ]),
      ));
    },
    act: (_) => bloc.add(AchievementsEventInitialize()),
    expect: () => [
      AchievementsState(
        status: AchievementsStatusLoaded(),
        daysStreak: 3,
        allFlashcardsAmount: 3,
      ),
      const AchievementsState(
        status: AchievementsStatusDaysStreakUpdated(newDaysStreak: 4),
        daysStreak: 4,
        allFlashcardsAmount: 3,
      ),
    ],
  );

  blocTest(
    'user state updated, days streak has not been changed',
    build: () => bloc,
    setUp: () {
      when(() => userBloc.stream).thenAnswer(
        (_) => Stream.value(UserState(
          loggedUser: createUser(days: [
            createDay(date: Date.now()),
            createDay(date: Date.now().subtractDays(2)),
            createDay(date: Date.now().subtractDays(1)),
          ]),
        )),
      );
      when(() => userBloc.state).thenReturn(UserState(
        loggedUser: createUser(days: [
          createDay(date: Date.now()),
          createDay(date: Date.now().subtractDays(2)),
          createDay(date: Date.now().subtractDays(1)),
        ]),
      ));
    },
    act: (_) => bloc.add(AchievementsEventInitialize()),
    expect: () => [
      AchievementsState(
        status: AchievementsStatusLoaded(),
        daysStreak: 3,
        allFlashcardsAmount: 3,
      ),
    ],
  );

  blocTest(
    'flashcards state updated',
    build: () => bloc,
    setUp: () {
      when(() => userBloc.state).thenReturn(const UserState());
      when(() => flashcardsBloc.stream).thenAnswer(
        (_) => Stream.value(
          FlashcardsState(
            groupsState: GroupsState(
              allGroups: [
                createGroup(flashcards: [createFlashcard(), createFlashcard()]),
                createGroup(flashcards: [createFlashcard()]),
                createGroup(flashcards: [createFlashcard(), createFlashcard()]),
              ],
            ),
          ),
        ),
      );
    },
    act: (_) => bloc.add(AchievementsEventInitialize()),
    expect: () => [
      AchievementsState(
        status: AchievementsStatusLoaded(),
        daysStreak: 0,
        allFlashcardsAmount: 3,
      ),
      AchievementsState(
        status: AchievementsStatusLoaded(),
        daysStreak: 0,
        allFlashcardsAmount: 5,
      ),
    ],
  );

  blocTest(
    'new condition achieved',
    build: () => bloc,
    act: (_) => bloc.add(
      AchievementsEventNewConditionAchieved(
        achievementType: AchievementType.amountOfFinishedSessions,
        completedConditionValue: 250,
      ),
    ),
    expect: () => [
      const AchievementsState(
        status: AchievementsStatusNewConditionCompleted(
          achievementType: AchievementType.amountOfFinishedSessions,
          completedConditionValue: 250,
        ),
      ),
    ],
  );

  blocTest(
    'add new flashcards',
    build: () => bloc,
    setUp: () {
      when(
        () => achievementsInterface.addNewFlashcards(
          flashcardsIds: any(named: 'flashcardsIds'),
          onAchievedNextCondition: any(named: 'onAchievedNextCondition'),
        ),
      ).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(
      AchievementsEventAddNewFlashcards(
        groupId: 'g1',
        flashcardsIndexes: const [1, 2, 5],
      ),
    ),
    verify: (_) {
      verify(
        () => achievementsInterface.addNewFlashcards(
          flashcardsIds: ['g11', 'g12', 'g15'],
          onAchievedNextCondition: any(named: 'onAchievedNextCondition'),
        ),
      ).called(1);
    },
  );

  blocTest(
    'add remembered flashcards',
    build: () => bloc,
    setUp: () {
      when(
        () => achievementsInterface.addNewRememberedFlashcards(
          flashcardsIds: any(named: 'flashcardsIds'),
          onAchievedNextCondition: any(named: 'onAchievedNextCondition'),
        ),
      ).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(
      AchievementsEventAddRememberedFlashcards(
        groupId: 'g1',
        rememberedFlashcardsIndexes: const [1, 2, 5],
      ),
    ),
    verify: (_) {
      verify(
        () => achievementsInterface.addNewRememberedFlashcards(
          flashcardsIds: ['g11', 'g12', 'g15'],
          onAchievedNextCondition: any(named: 'onAchievedNextCondition'),
        ),
      ).called(1);
    },
  );

  blocTest(
    'add session',
    build: () => bloc,
    setUp: () {
      when(
        () => achievementsInterface.addNewFinishedSession(
          sessionId: 's1',
          onAchievedNextCondition: any(named: 'onAchievedNextCondition'),
        ),
      ).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(AchievementsEventAddSession(sessionId: 's1')),
    verify: (_) {
      verify(
        () => achievementsInterface.addNewFinishedSession(
          sessionId: 's1',
          onAchievedNextCondition: any(named: 'onAchievedNextCondition'),
        ),
      ).called(1);
    },
  );
}
