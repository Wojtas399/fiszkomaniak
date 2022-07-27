import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/user/delete_avatar_use_case.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';

class MockUserInterface extends Mock implements UserInterface {}

void main() {
  final userInterface = MockUserInterface();
  final useCase = DeleteAvatarUseCase(userInterface: userInterface);

  test(
    'should call method responsible for deleting avatar',
    () async {
      when(() => userInterface.deleteAvatar()).thenAnswer((_) async => '');

      await useCase.execute();

      verify(() => userInterface.deleteAvatar()).called(1);
    },
  );
}
