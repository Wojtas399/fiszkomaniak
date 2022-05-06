import 'package:fiszkomaniak/firebase/services/fire_user_service.dart';
import 'package:fiszkomaniak/repositories/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFireUserService extends Mock implements FireUserService {}

void main() {
  final FireUserService fireUserService = MockFireUserService();
  late UserRepository repository;

  setUp(() {
    repository = UserRepository(fireUserService: fireUserService);
  });

  tearDown(() {
    reset(fireUserService);
  });

  test('save new remembered flashcards in days', () async {
    when(
      () => fireUserService.saveNewRememberedFlashcards('g1', [0, 1]),
    ).thenAnswer((_) async => '');

    await repository.saveNewRememberedFlashcardsInDays(
      groupId: 'g1',
      indexesOfFlashcards: [0, 1],
    );

    verify(
      () => fireUserService.saveNewRememberedFlashcards('g1', [0, 1]),
    ).called(1);
  });
}
