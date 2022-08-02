import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/user/get_user_avatar_url_use_case.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';

class MockUserInterface extends Mock implements UserInterface {}

void main() {
  final userInterface = MockUserInterface();
  final useCase = GetUserAvatarUrlUseCase(userInterface: userInterface);

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
}
