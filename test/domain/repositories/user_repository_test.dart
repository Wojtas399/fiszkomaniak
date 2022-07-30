import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/day.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/entities/user.dart';
import 'package:fiszkomaniak/domain/repositories/user_repository.dart';
import 'package:fiszkomaniak/firebase/models/day_db_model.dart';
import 'package:fiszkomaniak/firebase/models/fire_doc_model.dart';
import 'package:fiszkomaniak/firebase/models/user_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_days_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_user_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_avatar_service.dart';
import 'package:fiszkomaniak/firebase/fire_extensions.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/utils/days_streak_utils.dart';

class MockFireUserService extends Mock implements FireUserService {}

class MockFireAvatarService extends Mock implements FireAvatarService {}

class MockFireDaysService extends Mock implements FireDaysService {}

class MockDaysStreakUtils extends Mock implements DaysStreakUtils {}

void main() {
  final fireUserService = MockFireUserService();
  final fireAvatarService = MockFireAvatarService();
  final fireDaysService = MockFireDaysService();
  final daysStreakUtils = MockDaysStreakUtils();
  late UserRepository repository;
  const List<Date> dates = [
    Date(year: 2022, month: 5, day: 6),
    Date(year: 2022, month: 5, day: 5),
    Date(year: 2022, month: 5, day: 4),
  ];
  final FireDoc<UserDbModel> dbUser = FireDoc(
    id: 'u1',
    doc: UserDbModel(
      username: 'username',
      days: [
        createDayDbModel(date: dates[0].toDbString()),
        createDayDbModel(date: dates[1].toDbString()),
        createDayDbModel(date: dates[2].toDbString()),
      ],
    ),
  );
  final User user = createUser(
    avatarUrl: 'avatar/url',
    username: 'username',
    email: 'email',
    days: [
      createDay(date: dates[0]),
      createDay(date: dates[1]),
      createDay(date: dates[2]),
    ],
  );

  setUp(
    () => repository = UserRepository(
      fireUserService: fireUserService,
      fireAvatarService: fireAvatarService,
      fireDaysService: fireDaysService,
      daysStreakUtils: daysStreakUtils,
    ),
  );

  tearDown(() {
    reset(fireUserService);
    reset(fireAvatarService);
    reset(fireDaysService);
    reset(daysStreakUtils);
  });

  setUp(() {
    when(
      () => fireUserService.loadLoggedUserData(),
    ).thenAnswer((_) async => dbUser);
    when(
      () => fireAvatarService.loadLoggedUserAvatarUrl(),
    ).thenAnswer((_) async => user.avatarUrl);
    when(
      () => fireUserService.getLoggedUserEmail(),
    ).thenReturn(user.email);
    when(
      () => daysStreakUtils.getStreak(user.days),
    ).thenReturn(3);
  });

  test(
    'user, should return loaded user',
    () async {
      await repository.loadUser();

      expect(await repository.user$.first, user);
    },
  );

  test(
    'avatar url, should return avatar url of loaded user',
    () async {
      await repository.loadUser();

      expect(
        await repository.avatarUrl$.first,
        user.avatarUrl,
      );
    },
  );

  test(
    'days streak, should return amount of days in a row',
    () async {
      await repository.loadUser();

      expect(await repository.daysStreak$.first, 3);
    },
  );

  test(
    'load user, should load user data and avatar url from db',
    () async {
      await repository.loadUser();

      verify(() => fireUserService.loadLoggedUserData()).called(1);
      verify(() => fireAvatarService.loadLoggedUserAvatarUrl()).called(1);
    },
  );

  test(
    'add user data, should call method responsible for adding user data',
    () async {
      when(
        () => fireUserService.addUserData('userId', 'username'),
      ).thenAnswer((_) async => '');

      await repository.addUserData(
        userId: 'userId',
        username: 'username',
      );

      verify(
        () => fireUserService.addUserData('userId', 'username'),
      ).called(1);
    },
  );

  test(
    'update avatar, should call method responsible for updating avatar and should update avatar url in user stream',
    () async {
      when(
        () => fireAvatarService.saveNewLoggedUserAvatar('imagePath'),
      ).thenAnswer((_) async => '');
      when(
        () => fireAvatarService.loadLoggedUserAvatarUrl(),
      ).thenAnswer((_) async => 'new/url');

      await repository.loadUser();
      await repository.updateAvatar(imagePath: 'imagePath');

      expect(
        await repository.user$.first,
        user.copyWithAvatarUrl('new/url'),
      );
      verify(
        () => fireAvatarService.saveNewLoggedUserAvatar('imagePath'),
      ).called(1);
      verify(() => fireAvatarService.loadLoggedUserAvatarUrl()).called(2);
    },
  );

  test(
    'update username, should call method responsible for updating username and should update username in stream',
    () async {
      when(
        () => fireUserService.saveNewUsername('newUsername'),
      ).thenAnswer((_) async => '');

      await repository.loadUser();
      await repository.updateUsername(newUsername: 'newUsername');

      expect(
        await repository.user$.first,
        user.copyWith(username: 'newUsername'),
      );
      verify(
        () => fireUserService.saveNewUsername('newUsername'),
      ).called(1);
    },
  );

  test(
    'add remembered flashcards to current day, should call method responsible for saving remembered flashcards to current day and should update days in stream',
    () async {
      const String groupId = 'g1';
      final List<Flashcard> rememberedFlashcards = [
        createFlashcard(index: 0),
        createFlashcard(index: 1),
      ];
      final List<String> flashcardsIds = rememberedFlashcards
          .map((Flashcard flashcard) => flashcard.getId(groupId: groupId))
          .toList();
      final List<DayDbModel> updatedDbDays = [
        DayDbModel(
          date: '2022-07-30',
          rememberedFlashcardsIds: flashcardsIds,
        ),
      ];
      final List<Day> updatedDays = [
        createDay(
          date: const Date(year: 2022, month: 7, day: 30),
          amountOfRememberedFlashcards: 2,
        ),
      ];
      when(
        () => fireDaysService.saveRememberedFlashcardsToCurrentDay(
          flashcardsIds: flashcardsIds,
        ),
      ).thenAnswer((_) async => updatedDbDays);

      await repository.loadUser();
      await repository.addRememberedFlashcardsToCurrentDay(
        groupId: groupId,
        rememberedFlashcards: rememberedFlashcards,
      );

      expect(
        await repository.user$.first,
        user.copyWith(days: updatedDays),
      );
      verify(
        () => fireDaysService.saveRememberedFlashcardsToCurrentDay(
          flashcardsIds: flashcardsIds,
        ),
      ).called(1);
    },
  );

  test(
    'delete avatar, should call method responsible for deleting avatar and should remove avatar url from stream',
    () async {
      when(
        () => fireAvatarService.removeLoggedUserAvatar(),
      ).thenAnswer((_) async => '');

      await repository.loadUser();
      await repository.deleteAvatar();

      expect(
        await repository.user$.first,
        user.copyWithAvatarUrl(null),
      );
      verify(() => fireAvatarService.removeLoggedUserAvatar()).called(1);
    },
  );

  test(
    'delete all user data, should call method responsible for deleting all user data',
    () async {
      when(
        () => fireUserService.removeLoggedUserData(),
      ).thenAnswer((_) async => '');

      await repository.deleteAllUserData();

      verify(() => fireUserService.removeLoggedUserData()).called(1);
    },
  );

  test(
    'reset, should set initial user stream value',
    () async {
      await repository.loadUser();
      expect(await repository.user$.first, user);

      repository.reset();
      expect(await repository.user$.first, null);
    },
  );
}
