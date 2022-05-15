import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_state.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/core/user/user_bloc.dart';
import 'package:fiszkomaniak/features/profile/bloc/profile_bloc.dart';
import 'package:fiszkomaniak/features/profile/components/password_editor/bloc/password_editor_bloc.dart';
import 'package:fiszkomaniak/features/profile/profile_dialogs.dart';
import 'package:fiszkomaniak/models/day_model.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:fiszkomaniak/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

class MockUserBloc extends Mock implements UserBloc {}

class MockUserEvent extends Mock implements UserEvent {}

class MockAuthBloc extends Mock implements AuthBloc {}

class MockAuthEvent extends Mock implements AuthEvent {}

class MockFlashcardsBloc extends Mock implements FlashcardsBloc {}

class MockProfileDialogs extends Mock implements ProfileDialogs {}

class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  final UserBloc userBloc = MockUserBloc();
  final AuthBloc authBloc = MockAuthBloc();
  final FlashcardsBloc flashcardsBloc = MockFlashcardsBloc();
  final ProfileDialogs profileDialogs = MockProfileDialogs();
  final ImagePicker imagePicker = MockImagePicker();
  late ProfileBloc bloc;
  final User loggedUser = createUser(
    username: 'username',
    avatarUrl: 'avatar/url',
    days: [
      createDay(date: DateTime.now()),
      createDay(date: DateTime.now().subtract(const Duration(days: 1))),
      createDay(date: DateTime.now().subtract(const Duration(days: 2))),
      createDay(date: DateTime.now().subtract(const Duration(days: 3))),
    ],
  );
  final FlashcardsState flashcardsState = FlashcardsState(
    groupsState: GroupsState(
      allGroups: [
        createGroup(flashcards: [
          createFlashcard(index: 0),
          createFlashcard(index: 1),
          createFlashcard(index: 2),
        ]),
        createGroup(flashcards: [
          createFlashcard(index: 0),
          createFlashcard(index: 1),
        ]),
      ],
    ),
  );

  setUp(() {
    bloc = ProfileBloc(
      userBloc: userBloc,
      authBloc: authBloc,
      flashcardsBloc: flashcardsBloc,
      profileDialogs: profileDialogs,
      imagePicker: imagePicker,
    );
    when(() => userBloc.state).thenReturn(UserState(
      loggedUser: loggedUser,
    ));
    when(() => flashcardsBloc.state).thenReturn(flashcardsState);
    when(() => userBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => flashcardsBloc.stream).thenAnswer((_) => const Stream.empty());
    registerFallbackValue(MockUserEvent());
    registerFallbackValue(MockAuthEvent());
  });

  tearDown(() {
    reset(userBloc);
    reset(authBloc);
    reset(flashcardsBloc);
    reset(profileDialogs);
    reset(imagePicker);
  });

  blocTest(
    'initialize',
    build: () => bloc,
    act: (_) => bloc.add(ProfileEventInitialize()),
    expect: () => [
      ProfileState(
        loggedUserData: loggedUser,
        amountOfDaysInARow: 4,
        amountOfAllFlashcards: 5,
      ),
    ],
  );

  blocTest(
    'user updated',
    build: () => bloc,
    act: (_) => bloc.add(ProfileEventUserUpdated(
      newUserData: loggedUser,
      amountOfDaysInARow: 3,
    )),
    expect: () => [
      ProfileState(
        loggedUserData: loggedUser,
        amountOfDaysInARow: 3,
      )
    ],
  );

  blocTest(
    'flashcards state updated',
    build: () => bloc,
    act: (_) => bloc.add(ProfileEventFlashcardsStateUpdated(
      amountOfAllFlashcards: 4,
    )),
    expect: () => [
      const ProfileState(amountOfAllFlashcards: 4),
    ],
  );

  blocTest(
    'modify avatar, no avatar set',
    build: () => ProfileBloc(
      userBloc: userBloc,
      authBloc: authBloc,
      flashcardsBloc: flashcardsBloc,
      profileDialogs: profileDialogs,
      imagePicker: imagePicker,
    ),
    setUp: () {
      when(() => profileDialogs.askForImageSource())
          .thenAnswer((_) async => ImageSource.gallery);
      when(() => imagePicker.pickImage(source: ImageSource.gallery))
          .thenAnswer((_) async => XFile('path/to/file'));
      when(() => profileDialogs.askForImageConfirmation('path/to/file'))
          .thenAnswer((_) async => true);
    },
    act: (ProfileBloc profileBloc) => profileBloc.add(
      ProfileEventModifyAvatar(),
    ),
    verify: (_) {
      verify(() => profileDialogs.askForImageSource()).called(1);
      verify(() => imagePicker.pickImage(source: ImageSource.gallery))
          .called(1);
      verify(() => profileDialogs.askForImageConfirmation('path/to/file'))
          .called(1);
      verify(
        () => userBloc.add(
          UserEventSaveNewAvatar(imageFullPath: 'path/to/file'),
        ),
      ).called(1);
    },
  );

  blocTest(
    'modify avatar, edit, image source not selected',
    build: () => bloc,
    setUp: () {
      when(() => profileDialogs.askForAvatarAction())
          .thenAnswer((_) async => AvatarActions.edit);
      when(() => profileDialogs.askForImageSource())
          .thenAnswer((_) async => null);
      when(() => imagePicker.pickImage(source: ImageSource.gallery))
          .thenAnswer((_) async => XFile('path/to/file'));
      when(() => profileDialogs.askForImageConfirmation('path/to/file'))
          .thenAnswer((_) async => true);
    },
    act: (_) {
      bloc.add(ProfileEventInitialize());
      bloc.add(ProfileEventModifyAvatar());
    },
    verify: (_) {
      verify(() => profileDialogs.askForAvatarAction()).called(1);
      verify(() => profileDialogs.askForImageSource()).called(1);
      verifyNever(() => imagePicker.pickImage(source: ImageSource.gallery));
      verifyNever(() => profileDialogs.askForImageConfirmation('path/to/file'));
      verifyNever(
        () => userBloc.add(
          UserEventSaveNewAvatar(imageFullPath: 'path/to/file'),
        ),
      );
    },
  );

  blocTest(
    'modify avatar, edit, image not selected',
    build: () => bloc,
    setUp: () {
      when(() => profileDialogs.askForAvatarAction())
          .thenAnswer((_) async => AvatarActions.edit);
      when(() => profileDialogs.askForImageSource())
          .thenAnswer((_) async => ImageSource.gallery);
      when(() => imagePicker.pickImage(source: ImageSource.gallery))
          .thenAnswer((_) async => null);
      when(() => profileDialogs.askForImageConfirmation('path/to/file'))
          .thenAnswer((_) async => true);
    },
    act: (_) {
      bloc.add(ProfileEventInitialize());
      bloc.add(ProfileEventModifyAvatar());
    },
    verify: (_) {
      verify(() => profileDialogs.askForAvatarAction()).called(1);
      verify(() => profileDialogs.askForImageSource()).called(1);
      verify(() => imagePicker.pickImage(source: ImageSource.gallery))
          .called(1);
      verifyNever(() => profileDialogs.askForImageConfirmation('path/to/file'));
      verifyNever(
        () => userBloc.add(
          UserEventSaveNewAvatar(imageFullPath: 'path/to/file'),
        ),
      );
    },
  );

  blocTest(
    'modify avatar, edit, confirmed',
    build: () => bloc,
    setUp: () {
      when(() => profileDialogs.askForAvatarAction())
          .thenAnswer((_) async => AvatarActions.edit);
      when(() => profileDialogs.askForImageSource())
          .thenAnswer((_) async => ImageSource.gallery);
      when(() => imagePicker.pickImage(source: ImageSource.gallery))
          .thenAnswer((_) async => XFile('path/to/file'));
      when(() => profileDialogs.askForImageConfirmation('path/to/file'))
          .thenAnswer((_) async => true);
    },
    act: (_) {
      bloc.add(ProfileEventInitialize());
      bloc.add(ProfileEventModifyAvatar());
    },
    verify: (_) {
      verify(() => profileDialogs.askForAvatarAction()).called(1);
      verify(() => profileDialogs.askForImageSource()).called(1);
      verify(() => imagePicker.pickImage(source: ImageSource.gallery))
          .called(1);
      verify(() => profileDialogs.askForImageConfirmation('path/to/file'))
          .called(1);
      verify(
        () => userBloc.add(
          UserEventSaveNewAvatar(imageFullPath: 'path/to/file'),
        ),
      ).called(1);
    },
  );

  blocTest(
    'modify avatar, edit, cancelled',
    build: () => bloc,
    setUp: () {
      when(() => profileDialogs.askForAvatarAction())
          .thenAnswer((_) async => AvatarActions.edit);
      when(() => profileDialogs.askForImageSource())
          .thenAnswer((_) async => ImageSource.gallery);
      when(() => imagePicker.pickImage(source: ImageSource.gallery))
          .thenAnswer((_) async => XFile('path/to/file'));
      when(() => profileDialogs.askForImageConfirmation('path/to/file'))
          .thenAnswer((_) async => false);
    },
    act: (_) {
      bloc.add(ProfileEventInitialize());
      bloc.add(ProfileEventModifyAvatar());
    },
    verify: (_) {
      verify(() => profileDialogs.askForAvatarAction()).called(1);
      verify(() => profileDialogs.askForImageSource()).called(1);
      verify(() => imagePicker.pickImage(source: ImageSource.gallery))
          .called(1);
      verify(() => profileDialogs.askForImageConfirmation('path/to/file'))
          .called(1);
      verifyNever(
        () => userBloc.add(
          UserEventSaveNewAvatar(imageFullPath: 'path/to/file'),
        ),
      );
    },
  );

  blocTest(
    'modify avatar, delete, confirmed',
    build: () => bloc,
    setUp: () {
      when(() => profileDialogs.askForAvatarAction())
          .thenAnswer((_) async => AvatarActions.delete);
      when(() => profileDialogs.askForDeleteAvatarConfirmation())
          .thenAnswer((_) async => true);
    },
    act: (_) {
      bloc.add(ProfileEventInitialize());
      bloc.add(ProfileEventModifyAvatar());
    },
    verify: (_) {
      verify(() => profileDialogs.askForAvatarAction()).called(1);
      verify(() => profileDialogs.askForDeleteAvatarConfirmation()).called(1);
      verify(() => userBloc.add(UserEventRemoveAvatar())).called(1);
    },
  );

  blocTest(
    'modify avatar, delete, cancelled',
    build: () => bloc,
    setUp: () {
      when(() => profileDialogs.askForAvatarAction())
          .thenAnswer((_) async => AvatarActions.delete);
      when(() => profileDialogs.askForDeleteAvatarConfirmation())
          .thenAnswer((_) async => false);
    },
    act: (_) {
      bloc.add(ProfileEventInitialize());
      bloc.add(ProfileEventModifyAvatar());
    },
    verify: (_) {
      verify(() => profileDialogs.askForAvatarAction()).called(1);
      verify(() => profileDialogs.askForDeleteAvatarConfirmation()).called(1);
      verifyNever(() => userBloc.add(UserEventRemoveAvatar()));
    },
  );

  blocTest(
    'change username, new username as String',
    build: () => bloc,
    setUp: () {
      when(() => profileDialogs.askForNewUsername(loggedUser.username))
          .thenAnswer((_) async => 'new username');
    },
    act: (_) {
      bloc.add(ProfileEventInitialize());
      bloc.add(ProfileEventChangeUsername());
    },
    verify: (_) {
      verify(() => profileDialogs.askForNewUsername(loggedUser.username))
          .called(1);
      verify(
        () => userBloc.add(
          UserEventChangeUsername(newUsername: 'new username'),
        ),
      ).called(1);
    },
  );

  blocTest(
    'change username, new username as null',
    build: () => bloc,
    setUp: () {
      when(() => profileDialogs.askForNewUsername(loggedUser.username))
          .thenAnswer((_) async => null);
    },
    act: (_) {
      bloc.add(ProfileEventInitialize());
      bloc.add(ProfileEventChangeUsername());
    },
    verify: (_) {
      verify(() => profileDialogs.askForNewUsername(loggedUser.username))
          .called(1);
      verifyNever(() => userBloc.add(any()));
    },
  );

  blocTest(
    'change password, password editor returned correct values',
    build: () => bloc,
    setUp: () {
      when(() => profileDialogs.askForNewPassword()).thenAnswer(
        (_) async => const PasswordEditorReturns(
          currentPassword: 'current password',
          newPassword: 'new password',
        ),
      );
    },
    act: (_) => bloc.add(ProfileEventChangePassword()),
    verify: (_) {
      verify(
        () => authBloc.add(
          AuthEventChangePassword(
            currentPassword: 'current password',
            newPassword: 'new password',
          ),
        ),
      ).called(1);
    },
  );

  blocTest(
    'change password, password editor returned null',
    build: () => bloc,
    setUp: () {
      when(() => profileDialogs.askForNewPassword()).thenAnswer(
        (_) async => null,
      );
    },
    act: (_) => bloc.add(ProfileEventChangePassword()),
    verify: (_) {
      verifyNever(() => authBloc.add(any()));
    },
  );
}
