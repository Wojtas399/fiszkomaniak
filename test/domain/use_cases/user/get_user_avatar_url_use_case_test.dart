import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/user/get_user_avatar_url_use_case.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';

class MockUserInterface extends Mock implements UserInterface {}

void main() {
  final userInterface = MockUserInterface();
  late GetUserAvatarUrlUseCase useCase;

  setUp(
    () => useCase = GetUserAvatarUrlUseCase(userInterface: userInterface),
  );

  tearDown(() {
    reset(userInterface);
  });

  test(
    'should return stream with logged user avatar url',
    () async {
      when(
        () => userInterface.avatarUrl$,
      ).thenAnswer((_) => Stream.value('avatar/url'));

      expect(
        await useCase.execute().first,
        'avatar/url',
      );
    },
  );

  test(
    'should return stream with null if stream from interface has not been set yet',
    () async {
      when(() => userInterface.avatarUrl$).thenAnswer((_) => null);

      expect(await useCase.execute().first, null);
    },
  );
}
