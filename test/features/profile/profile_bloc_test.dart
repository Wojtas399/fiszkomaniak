import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/achievements/achievements_bloc.dart';
import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/core/user/user_bloc.dart';
import 'package:fiszkomaniak/features/profile/bloc/profile_bloc.dart';
import 'package:fiszkomaniak/features/profile/components/password_editor/bloc/password_editor_bloc.dart';
import 'package:fiszkomaniak/features/profile/profile_dialogs.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/day_model.dart';
import 'package:fiszkomaniak/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

class MockUserBloc extends Mock implements UserBloc {}

class MockUserEvent extends Mock implements UserEvent {}

class MockAuthBloc extends Mock implements AuthBloc {}

class MockAuthEvent extends Mock implements AuthEvent {}

class MockAchievementsBloc extends Mock implements AchievementsBloc {}

class MockProfileDialogs extends Mock implements ProfileDialogs {}

class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  final UserBloc userBloc = MockUserBloc();
  final AuthBloc authBloc = MockAuthBloc();
  final AchievementsBloc achievementsBloc = MockAchievementsBloc();
  final ProfileDialogs profileDialogs = MockProfileDialogs();
  final ImagePicker imagePicker = MockImagePicker();
  late ProfileBloc bloc;
  final Date now = Date.now();
  final User loggedUser = createUser(
    username: 'username',
    avatarUrl: 'avatar/url',
    days: [
      createDay(date: now),
      createDay(date: now.subtractDays(1)),
      createDay(date: now.subtractDays(2)),
      createDay(date: now.subtractDays(3)),
    ],
  );
  const AchievementsState achievementsState = AchievementsState(
    daysStreak: 5,
    allFlashcardsAmount: 200,
  );

  setUp(() {
    bloc = ProfileBloc(
      userBloc: userBloc,
      authBloc: authBloc,
      achievementsBloc: achievementsBloc,
      profileDialogs: profileDialogs,
      imagePicker: imagePicker,
    );
    when(() => userBloc.state).thenReturn(UserState(
      loggedUser: loggedUser,
    ));
    when(() => achievementsBloc.state).thenReturn(achievementsState);
    when(() => userBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => achievementsBloc.stream).thenAnswer((_) => const Stream.empty());
    registerFallbackValue(MockUserEvent());
    registerFallbackValue(MockAuthEvent());
  });

  tearDown(() {
    reset(userBloc);
    reset(authBloc);
    reset(achievementsBloc);
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
        amountOfDaysInARow: 5,
        amountOfAllFlashcards: 200,
      ),
    ],
  );

  blocTest(
    'user state updated',
    build: () => bloc,
    act: (_) => bloc.add(ProfileEventUserStateUpdated(newUserData: loggedUser)),
    expect: () => [ProfileState(loggedUserData: loggedUser)],
  );

  blocTest(
    'achievements state updated',
    build: () => bloc,
    act: (_) => bloc.add(ProfileEventAchievementsStateUpdated(
      daysStreak: 6,
      allFlashcardsAmount: 250,
    )),
    expect: () => [
      const ProfileState(amountOfDaysInARow: 6, amountOfAllFlashcards: 250),
    ],
  );

  blocTest(
    'modify avatar, no avatar set',
    build: () => ProfileBloc(
      userBloc: userBloc,
      authBloc: authBloc,
      achievementsBloc: achievementsBloc,
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

  blocTest(
    'sign out, confirmed',
    build: () => bloc,
    setUp: () {
      when(() => profileDialogs.askForSignOutConfirmation())
          .thenAnswer((_) async => true);
    },
    act: (_) => bloc.add(ProfileEventSignOut()),
    verify: (_) {
      verify(() => authBloc.add(AuthEventSignOut())).called(1);
    },
  );

  blocTest(
    'sign out, cancelled',
    build: () => bloc,
    setUp: () {
      when(() => profileDialogs.askForSignOutConfirmation())
          .thenAnswer((_) async => false);
    },
    act: (_) => bloc.add(ProfileEventSignOut()),
    verify: (_) {
      verifyNever(() => authBloc.add(any()));
    },
  );

  blocTest(
    'remove account, password as string',
    build: () => bloc,
    setUp: () {
      when(() => profileDialogs.askForRemoveAccountConfirmationPassword())
          .thenAnswer((_) async => 'password');
    },
    act: (_) => bloc.add(ProfileEventRemoveAccount()),
    verify: (_) {
      verify(
        () => authBloc.add(AuthEventRemoveLoggedUser(password: 'password')),
      ).called(1);
    },
  );

  blocTest(
    'remove account, password as null',
    build: () => bloc,
    setUp: () {
      when(() => profileDialogs.askForRemoveAccountConfirmationPassword())
          .thenAnswer((_) async => null);
    },
    act: (_) => bloc.add(ProfileEventRemoveAccount()),
    verify: (_) {
      verifyNever(() => authBloc.add(any()));
    },
  );
}
