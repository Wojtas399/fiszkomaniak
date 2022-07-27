import 'package:fiszkomaniak/domain/use_cases/auth/sign_out_use_case.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthInterface extends Mock implements AuthInterface {}

class MockUserInterface extends Mock implements UserInterface {}

void main() {
  final authInterface = MockAuthInterface();
  final userInterface = MockUserInterface();
  final useCase = SignOutUseCase(
    authInterface: authInterface,
    userInterface: userInterface,
  );

  test(
    'should call method responsible for signing out user and methods responsible for resetting repositories',
    () async {
      when(() => authInterface.signOut()).thenAnswer((_) async => '');

      await useCase.execute();

      verify(() => authInterface.signOut()).called(1);
      verify(() => userInterface.reset()).called(1);
    },
  );
}
