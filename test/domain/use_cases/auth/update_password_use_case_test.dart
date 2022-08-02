import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/auth/update_password_use_case.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';

class MockAuthInterface extends Mock implements AuthInterface {}

void main() {
  final authInterface = MockAuthInterface();
  final useCase = UpdatePasswordUseCase(authInterface: authInterface);

  test(
    'should call method responsible for updating password',
    () async {
      when(
        () => authInterface.updatePassword(
            currentPassword: 'currentPassword', newPassword: 'newPassword'),
      ).thenAnswer((_) async => '');

      await useCase.execute(
        currentPassword: 'currentPassword',
        newPassword: 'newPassword',
      );

      verify(
        () => authInterface.updatePassword(
          currentPassword: 'currentPassword',
          newPassword: 'newPassword',
        ),
      ).called(1);
    },
  );
}
