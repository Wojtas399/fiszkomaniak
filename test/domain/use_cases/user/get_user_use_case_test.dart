import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/user.dart';
import 'package:fiszkomaniak/domain/use_cases/user/get_user_use_case.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';

class MockUserInterface extends Mock implements UserInterface {}

void main() {
  final userInterface = MockUserInterface();
  late GetUserUseCase useCase;

  setUp(() => useCase = GetUserUseCase(userInterface: userInterface));

  tearDown(() {
    reset(userInterface);
  });

  test(
    'should return stream with user',
    () async {
      final User user = createUser(
        username: 'username',
        email: 'email',
      );
      when(() => userInterface.user$).thenAnswer((_) => Stream.value(user));

      expect(await useCase.execute().first, user);
    },
  );

  test(
    'should return stream with null if stream from interface has not been set yet',
    () async {
      when(() => userInterface.user$).thenAnswer((_) => null);

      expect(await useCase.execute().first, null);
    },
  );
}
