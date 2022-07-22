import 'package:fiszkomaniak/domain/use_cases/auth/is_user_logged_use_case.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthInterface extends Mock implements AuthInterface {}

void main() {
  final authInterface = MockAuthInterface();
  final useCase = IsUserLoggedUseCase(authInterface: authInterface);

  test(
    'should return stream with user login status',
    () async {
      when(
        () => authInterface.isUserLogged$,
      ).thenAnswer((_) => Stream.value(true));

      final Stream<bool> isUserLogged$ = useCase.execute();

      expect(await isUserLogged$.first, true);
    },
  );
}
