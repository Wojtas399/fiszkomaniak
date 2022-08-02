import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/user/load_user_use_case.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';

class MockUserInterface extends Mock implements UserInterface {}

void main() {
  final userInterface = MockUserInterface();
  final useCase = LoadUserUseCase(userInterface: userInterface);

  test(
    'should call method responsible for loading user',
    () async {
      when(() => userInterface.loadUser()).thenAnswer((_) async => '');

      await useCase.execute();

      verify(() => userInterface.loadUser()).called(1);
    },
  );
}
