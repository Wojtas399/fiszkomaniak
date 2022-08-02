import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/user/update_avatar_use_case.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';

class MockUserInterface extends Mock implements UserInterface {}

void main() {
  final userInterface = MockUserInterface();
  final useCase = UpdateAvatarUseCase(userInterface: userInterface);

  test(
    'should call method responsible for updating avatar',
    () async {
      when(
        () => userInterface.updateAvatar(imagePath: 'fullPath'),
      ).thenAnswer((_) async => '');

      await useCase.execute(imagePath: 'fullPath');

      verify(
        () => userInterface.updateAvatar(imagePath: 'fullPath'),
      ).called(1);
    },
  );
}
