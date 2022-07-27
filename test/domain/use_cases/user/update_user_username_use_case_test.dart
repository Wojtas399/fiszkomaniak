import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/user/update_user_username_use_case.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';

class MockUserInterface extends Mock implements UserInterface {}

void main() {
  final userInterface = MockUserInterface();
  final useCase = UpdateUserUsernameUseCase(userInterface: userInterface);

  test(
    'should call method responsible for updating logged user username',
    () async {
      when(
        () => userInterface.updateUsername(newUsername: 'newUsername'),
      ).thenAnswer((_) async => '');

      await useCase.execute(username: 'newUsername');

      verify(
        () => userInterface.updateUsername(newUsername: 'newUsername'),
      ).called(1);
    },
  );
}
