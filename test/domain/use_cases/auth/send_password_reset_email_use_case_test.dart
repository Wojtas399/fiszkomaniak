import 'package:fiszkomaniak/domain/use_cases/auth/send_password_reset_email_use_case.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthInterface extends Mock implements AuthInterface {}

void main() {
  final authInterface = MockAuthInterface();
  final useCase = SendPasswordResetEmailUseCase(authInterface: authInterface);

  test(
    'should call method responsible for sending password reset email',
    () async {
      when(
        () => authInterface.sendPasswordResetEmail('email'),
      ).thenAnswer((_) async => '');

      await useCase.execute(email: 'email');

      verify(() => authInterface.sendPasswordResetEmail('email')).called(1);
    },
  );
}
