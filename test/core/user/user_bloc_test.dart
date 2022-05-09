import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/user/user_bloc.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';
import 'package:fiszkomaniak/models/day_model.dart';
import 'package:fiszkomaniak/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserInterface extends Mock implements UserInterface {}

void main() {
  final UserInterface userInterface = MockUserInterface();
  late UserBloc bloc;

  setUp(() {
    bloc = UserBloc(userInterface: userInterface);
  });

  tearDown(() {
    reset(userInterface);
  });

  blocTest(
    'logged user updated',
    build: () => bloc,
    act: (_) => bloc.add(
      UserEventLoggedUserUpdated(
          updatedLoggedUser: createUser(days: [
        createDay(date: DateTime(2022, 5, 11)),
        createDay(date: DateTime(2022, 5, 22)),
      ])),
    ),
    expect: () => [
      UserState(
        status: UserStatusLoaded(),
        loggedUser: createUser(days: [
          createDay(date: DateTime(2022, 5, 11)),
          createDay(date: DateTime(2022, 5, 22)),
        ]),
      ),
    ],
  );

  blocTest(
    'save new remembered flashcards, success',
    build: () => bloc,
    setUp: () {
      when(
        () => userInterface.saveNewRememberedFlashcardsInDays(
          groupId: 'g1',
          indexesOfFlashcards: [0, 1],
        ),
      ).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(UserEventSaveNewRememberedFlashcards(
      groupId: 'g1',
      rememberedFlashcardsIndexes: const [0, 1],
    )),
    expect: () => [
      UserState(status: UserStatusLoading()),
      UserState(status: UserStatusNewRememberedFlashcardsSaved()),
    ],
    verify: (_) {
      verify(
        () => userInterface.saveNewRememberedFlashcardsInDays(
          groupId: 'g1',
          indexesOfFlashcards: [0, 1],
        ),
      ).called(1);
    },
  );

  blocTest(
    'save new remembered flashcards, failure',
    build: () => bloc,
    setUp: () {
      when(
        () => userInterface.saveNewRememberedFlashcardsInDays(
          groupId: 'g1',
          indexesOfFlashcards: [0, 1],
        ),
      ).thenThrow('Error...');
    },
    act: (_) => bloc.add(UserEventSaveNewRememberedFlashcards(
      groupId: 'g1',
      rememberedFlashcardsIndexes: const [0, 1],
    )),
    expect: () => [
      UserState(status: UserStatusLoading()),
      const UserState(status: UserStatusError(message: 'Error...')),
    ],
    verify: (_) {
      verify(
        () => userInterface.saveNewRememberedFlashcardsInDays(
          groupId: 'g1',
          indexesOfFlashcards: [0, 1],
        ),
      ).called(1);
    },
  );
}
