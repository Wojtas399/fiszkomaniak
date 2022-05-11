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
  const String errorMessage = 'Error...';
  final UserState loadingState = UserState(status: UserStatusLoading());
  const UserState errorState = UserState(
    status: UserStatusError(message: errorMessage),
  );

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
    'save new avatar, success',
    build: () => bloc,
    setUp: () {
      when(() => userInterface.saveNewAvatar(fullPath: 'full/path'))
          .thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(UserEventSaveNewAvatar(imageFullPath: 'full/path')),
    expect: () => [
      loadingState,
      UserState(status: UserStatusNewAvatarSaved()),
    ],
    verify: (_) {
      verify(() => userInterface.saveNewAvatar(fullPath: 'full/path'))
          .called(1);
    },
  );

  blocTest(
    'save new avatar, failure',
    build: () => bloc,
    setUp: () {
      when(() => userInterface.saveNewAvatar(fullPath: 'full/path'))
          .thenThrow(errorMessage);
    },
    act: (_) => bloc.add(UserEventSaveNewAvatar(imageFullPath: 'full/path')),
    expect: () => [loadingState, errorState],
    verify: (_) {
      verify(() => userInterface.saveNewAvatar(fullPath: 'full/path'))
          .called(1);
    },
  );

  blocTest(
    'remove avatar, success',
    build: () => bloc,
    setUp: () {
      when(() => userInterface.removeAvatar()).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(UserEventRemoveAvatar()),
    expect: () => [
      loadingState,
      UserState(status: UserStatusAvatarRemoved()),
    ],
    verify: (_) {
      verify(() => userInterface.removeAvatar()).called(1);
    },
  );

  blocTest(
    'remove avatar, failure',
    build: () => bloc,
    setUp: () {
      when(() => userInterface.removeAvatar()).thenThrow(errorMessage);
    },
    act: (_) => bloc.add(UserEventRemoveAvatar()),
    expect: () => [loadingState, errorState],
    verify: (_) {
      verify(() => userInterface.removeAvatar()).called(1);
    },
  );

  blocTest(
    'change username, success',
    build: () => bloc,
    setUp: () {
      when(() => userInterface.saveNewUsername(newUsername: 'newUsername'))
          .thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(UserEventChangeUsername(newUsername: 'newUsername')),
    expect: () => [
      loadingState,
      UserState(status: UserStatusUsernameUpdated()),
    ],
    verify: (_) {
      verify(() => userInterface.saveNewUsername(newUsername: 'newUsername'))
          .called(1);
    },
  );

  blocTest(
    'change username, failure',
    build: () => bloc,
    setUp: () {
      when(() => userInterface.saveNewUsername(newUsername: 'newUsername'))
          .thenThrow(errorMessage);
    },
    act: (_) => bloc.add(UserEventChangeUsername(newUsername: 'newUsername')),
    expect: () => [loadingState, errorState],
    verify: (_) {
      verify(() => userInterface.saveNewUsername(newUsername: 'newUsername'))
          .called(1);
    },
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
      loadingState,
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
      ).thenThrow(errorMessage);
    },
    act: (_) => bloc.add(UserEventSaveNewRememberedFlashcards(
      groupId: 'g1',
      rememberedFlashcardsIndexes: const [0, 1],
    )),
    expect: () => [loadingState, errorState],
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
