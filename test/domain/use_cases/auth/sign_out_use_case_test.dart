import 'package:fiszkomaniak/domain/use_cases/auth/sign_out_use_case.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthInterface extends Mock implements AuthInterface {}

void main() {
  final authInterface = MockAuthInterface();
  final useCase = SignOutUseCase(authInterface: authInterface);

  test(
    'should call method responsible for signing out user',
    () async {
      when(() => authInterface.signOut()).thenAnswer((_) async => '');

      await useCase.execute();

      verify(() => authInterface.signOut()).called(1);
    },
  );
}
