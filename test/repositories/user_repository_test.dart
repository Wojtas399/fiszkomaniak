import 'package:fiszkomaniak/firebase/services/fire_avatar_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_user_service.dart';
import 'package:fiszkomaniak/repositories/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFireUserService extends Mock implements FireUserService {}

class MockFireAvatarService extends Mock implements FireAvatarService {}

void main() {
  final FireUserService fireUserService = MockFireUserService();
  final FireAvatarService fireAvatarService = MockFireAvatarService();
  late UserRepository repository;

  setUp(() {
    repository = UserRepository(
      fireUserService: fireUserService,
      fireAvatarService: fireAvatarService,
    );
  });

  tearDown(() {
    reset(fireUserService);
    reset(fireAvatarService);
  });

  test('save new avatar', () async {
    const String avatarFullPath = '/avatar/full/path.jpg';
    when(() => fireAvatarService.saveNewLoggedUserAvatar(avatarFullPath))
        .thenAnswer((_) async => '');

    await repository.saveNewAvatar(fullPath: avatarFullPath);

    verify(() => fireAvatarService.saveNewLoggedUserAvatar(avatarFullPath))
        .called(1);
  });

  test('remove avatar', () async {
    when(() => fireAvatarService.removeLoggedUserAvatar())
        .thenAnswer((_) async => '');

    await repository.removeAvatar();

    verify(() => fireAvatarService.removeLoggedUserAvatar()).called(1);
  });

  test('save new remembered flashcards in days', () async {
    when(
      () => fireUserService.saveNewRememberedFlashcards('g1', [0, 1]),
    ).thenAnswer((_) async => '');

    await repository.saveNewRememberedFlashcardsInDays(
      groupId: 'g1',
      indexesOfFlashcards: [0, 1],
    );

    verify(
      () => fireUserService.saveNewRememberedFlashcards('g1', [0, 1]),
    ).called(1);
  });
}
