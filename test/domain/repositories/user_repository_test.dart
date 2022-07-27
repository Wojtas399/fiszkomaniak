import 'package:fiszkomaniak/domain/entities/user.dart';
import 'package:fiszkomaniak/firebase/models/fire_doc_model.dart';
import 'package:fiszkomaniak/firebase/models/user_db_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/firebase/services/fire_user_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_avatar_service.dart';
import 'package:fiszkomaniak/domain/repositories/user_repository.dart';

class MockFireUserService extends Mock implements FireUserService {}

class MockFireAvatarService extends Mock implements FireAvatarService {}

void main() {
  final fireUserService = MockFireUserService();
  final fireAvatarService = MockFireAvatarService();
  late UserRepository repository;
  final User user = createUser(
    avatarUrl: 'avatar/url',
    username: 'username',
    email: 'email',
  );

  setUp(
    () => repository = UserRepository(
      fireUserService: fireUserService,
      fireAvatarService: fireAvatarService,
    ),
  );

  tearDown(() {
    reset(fireUserService);
    reset(fireAvatarService);
  });

  setUp(() {
    const FireDoc<UserDbModel> dbUser = FireDoc(
      id: 'u1',
      doc: UserDbModel(username: 'username'),
    );
    when(
      () => fireUserService.loadLoggedUserData(),
    ).thenAnswer((_) async => dbUser);
    when(
      () => fireAvatarService.loadLoggedUserAvatarUrl(),
    ).thenAnswer((_) async => user.avatarUrl);
    when(() => fireUserService.getLoggedUserEmail()).thenReturn(user.email);
  });

  test(
    'user, should return loaded user',
    () async {
      await repository.loadUser();

      expect(await repository.user$?.first, user);
    },
  );

  test(
    'avatar url, should return avatar url of loaded user',
    () async {
      await repository.loadUser();

      expect(
        await repository.avatarUrl$?.first,
        user.avatarUrl,
      );
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
        await repository.user$?.first,
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
        await repository.user$?.first,
        user.copyWith(username: 'newUsername'),
      );
      verify(
        () => fireUserService.saveNewUsername('newUsername'),
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
        await repository.user$?.first,
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
    'reset, should set user stream as null',
    () async {
      await repository.loadUser();
      expect(await repository.user$?.first, user);

      repository.reset();
      expect(repository.user$, null);
    },
  );
}
