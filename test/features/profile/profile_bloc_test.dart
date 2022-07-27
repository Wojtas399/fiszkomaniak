import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/user.dart';
import 'package:fiszkomaniak/domain/use_cases/auth/delete_logged_user_account_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/auth/sign_out_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/auth/update_password_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/user/get_user_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/user/delete_avatar_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/user/update_avatar_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/user/update_user_username_use_case.dart';
import 'package:fiszkomaniak/exceptions/auth_exceptions.dart';
import 'package:fiszkomaniak/features/profile/bloc/profile_bloc.dart';
import 'package:fiszkomaniak/features/profile/profile_dialogs.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

class MockUpdateUserUsernameUseCase extends Mock
    implements UpdateUserUsernameUseCase {}

class MockUpdatePasswordUseCase extends Mock implements UpdatePasswordUseCase {}

class MockSignOutUseCase extends Mock implements SignOutUseCase {}

class MockDeleteLoggedUserAccountUseCase extends Mock
    implements DeleteLoggedUserAccountUseCase {}

class MockGetUserUseCase extends Mock implements GetUserUseCase {}

class MockUpdateAvatarUseCase extends Mock implements UpdateAvatarUseCase {}

class MockDeleteAvatarUseCase extends Mock implements DeleteAvatarUseCase {}

class MockProfileDialogs extends Mock implements ProfileDialogs {}

void main() {
  final updateUserUsernameUseCase = MockUpdateUserUsernameUseCase();
  final updatePasswordUseCase = MockUpdatePasswordUseCase();
  final signOutUseCase = MockSignOutUseCase();
  final deleteLoggedUserAccountUseCase = MockDeleteLoggedUserAccountUseCase();
  final getUserUseCase = MockGetUserUseCase();
  final updateAvatarUseCase = MockUpdateAvatarUseCase();
  final deleteAvatarUseCase = MockDeleteAvatarUseCase();
  final profileDialogs = MockProfileDialogs();

  ProfileBloc createBloc({
    BlocStatus status = const BlocStatusInitial(),
    User? user,
    int amountOfDaysStreak = 0,
    int amountOfAllFlashcards = 0,
  }) {
    return ProfileBloc(
      updateUserUsernameUseCase: updateUserUsernameUseCase,
      updatePasswordUseCase: updatePasswordUseCase,
      signOutUseCase: signOutUseCase,
      deleteLoggedUserAccountUseCase: deleteLoggedUserAccountUseCase,
      getUserUseCase: getUserUseCase,
      updateAvatarUseCase: updateAvatarUseCase,
      deleteAvatarUseCase: deleteAvatarUseCase,
      profileDialogs: profileDialogs,
      status: status,
      user: user,
      amountOfDaysStreak: amountOfDaysStreak,
      amountOfAllFlashcards: amountOfAllFlashcards,
    );
  }

  ProfileState createState({
    BlocStatus status = const BlocStatusComplete(),
    User? user,
    int amountOfDaysStreak = 0,
    int amountOfAllFlashcards = 0,
  }) {
    return ProfileState(
      status: status,
      user: user,
      amountOfDaysStreak: amountOfDaysStreak,
      amountOfAllFlashcards: amountOfAllFlashcards,
    );
  }

  tearDown(() {
    reset(updateUserUsernameUseCase);
    reset(updatePasswordUseCase);
    reset(signOutUseCase);
    reset(deleteLoggedUserAccountUseCase);
    reset(getUserUseCase);
    reset(updateAvatarUseCase);
    reset(deleteAvatarUseCase);
    reset(profileDialogs);
  });

  group(
    'initialize',
    () {
      final User user = createUser(username: 'username');

      blocTest(
        'should set user listener',
        build: () => createBloc(),
        setUp: () {
          when(
            () => getUserUseCase.execute(),
          ).thenAnswer((_) => Stream.value(user));
        },
        act: (ProfileBloc bloc) {
          bloc.add(ProfileEventInitialize());
        },
        expect: () => [
          createState(user: user),
        ],
        verify: (_) {
          verify(() => getUserUseCase.execute()).called(1);
        },
      );
    },
  );

  group(
    'user changed',
    () {
      final User user = createUser(username: 'username');

      blocTest(
        'should update user in state',
        build: () => createBloc(),
        act: (ProfileBloc bloc) {
          bloc.add(ProfileEventUserChanged(user: user));
        },
        expect: () => [
          createState(user: user),
        ],
      );
    },
  );

  group(
    'change avatar',
    () {
      const String imagePath = 'image/path';

      setUp(() {
        when(
          () => updateAvatarUseCase.execute(imagePath: imagePath),
        ).thenAnswer((_) async => '');
      });

      blocTest(
        'confirmed, should call use case responsible for updating avatar',
        build: () => createBloc(),
        setUp: () {
          when(
            () => profileDialogs.askForNewAvatarConfirmation(imagePath),
          ).thenAnswer((_) async => true);
        },
        act: (ProfileBloc bloc) {
          bloc.add(ProfileEventChangeAvatar(imagePath: imagePath));
        },
        expect: () => [
          createState(status: const BlocStatusLoading()),
          createState(
            status: const BlocStatusComplete<ProfileInfoType>(
              info: ProfileInfoType.avatarHasBeenUpdated,
            ),
          ),
        ],
        verify: (_) {
          verify(
            () => profileDialogs.askForNewAvatarConfirmation(imagePath),
          ).called(1);
          verify(
            () => updateAvatarUseCase.execute(imagePath: imagePath),
          ).called(1);
        },
      );

      blocTest(
        'cancelled, should not call use case responsible for updating avatar',
        build: () => createBloc(),
        setUp: () {
          when(
            () => profileDialogs.askForNewAvatarConfirmation(imagePath),
          ).thenAnswer((_) async => false);
        },
        act: (ProfileBloc bloc) {
          bloc.add(ProfileEventChangeAvatar(imagePath: imagePath));
        },
        expect: () => [],
        verify: (_) {
          verify(
            () => profileDialogs.askForNewAvatarConfirmation(imagePath),
          ).called(1);
          verifyNever(
            () => updateAvatarUseCase.execute(imagePath: imagePath),
          );
        },
      );
    },
  );

  group(
    'delete avatar',
    () {
      setUp(() {
        when(() => deleteAvatarUseCase.execute()).thenAnswer((_) async => '');
      });

      blocTest(
        'confirmed, should call use case responsible for deleting avatar',
        build: () => createBloc(),
        setUp: () {
          when(
            () => profileDialogs.askForAvatarDeletionConfirmation(),
          ).thenAnswer((_) async => true);
        },
        act: (ProfileBloc bloc) {
          bloc.add(ProfileEventDeleteAvatar());
        },
        expect: () => [
          createState(status: const BlocStatusLoading()),
          createState(
            status: const BlocStatusComplete<ProfileInfoType>(
              info: ProfileInfoType.avatarHasBeenDeleted,
            ),
          ),
        ],
        verify: (_) {
          verify(
            () => profileDialogs.askForAvatarDeletionConfirmation(),
          ).called(1);
          verify(() => deleteAvatarUseCase.execute()).called(1);
        },
      );

      blocTest(
        'cancelled, should not call use case responsible for deleting avatar',
        build: () => createBloc(),
        setUp: () {
          when(
            () => profileDialogs.askForAvatarDeletionConfirmation(),
          ).thenAnswer((_) async => false);
        },
        act: (ProfileBloc bloc) {
          bloc.add(ProfileEventDeleteAvatar());
        },
        expect: () => [],
        verify: (_) {
          verify(
            () => profileDialogs.askForAvatarDeletionConfirmation(),
          ).called(1);
          verifyNever(() => deleteAvatarUseCase.execute());
        },
      );
    },
  );

  blocTest(
    'change username, should call use case responsible for updating username',
    build: () => createBloc(),
    setUp: () {
      when(
        () => updateUserUsernameUseCase.execute(username: 'username'),
      ).thenAnswer((_) async => '');
    },
    act: (ProfileBloc bloc) {
      bloc.add(
        ProfileEventChangeUsername(newUsername: 'username'),
      );
    },
    expect: () => [
      createState(status: const BlocStatusLoading()),
      createState(
        status: const BlocStatusComplete<ProfileInfoType>(
          info: ProfileInfoType.usernameHasBeenUpdated,
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => updateUserUsernameUseCase.execute(username: 'username'),
      ).called(1);
    },
  );

  group(
    'change password',
    () {
      const String currentPassword = 'current';
      const String newPassword = 'new';

      blocTest(
        'should call use case responsible for updating password',
        build: () => createBloc(),
        setUp: () {
          when(
            () => updatePasswordUseCase.execute(
              currentPassword: currentPassword,
              newPassword: newPassword,
            ),
          ).thenAnswer((_) async => '');
        },
        act: (ProfileBloc bloc) {
          bloc.add(
            ProfileEventChangePassword(
              currentPassword: currentPassword,
              newPassword: newPassword,
            ),
          );
        },
        expect: () => [
          createState(status: const BlocStatusLoading()),
          createState(
            status: const BlocStatusComplete<ProfileInfoType>(
              info: ProfileInfoType.passwordHasBeenUpdated,
            ),
          ),
        ],
        verify: (_) {
          verify(
            () => updatePasswordUseCase.execute(
              currentPassword: currentPassword,
              newPassword: newPassword,
            ),
          ).called(1);
        },
      );

      blocTest(
        'should emit appropriate info type if use case throws wrong password exception',
        build: () => createBloc(),
        setUp: () {
          when(
            () => updatePasswordUseCase.execute(
              currentPassword: currentPassword,
              newPassword: newPassword,
            ),
          ).thenThrow(AuthException.wrongPassword);
        },
        act: (ProfileBloc bloc) {
          bloc.add(
            ProfileEventChangePassword(
              currentPassword: currentPassword,
              newPassword: newPassword,
            ),
          );
        },
        expect: () => [
          createState(status: const BlocStatusLoading()),
          createState(
            status: const BlocStatusError<ProfileErrorType>(
              errorType: ProfileErrorType.wrongPassword,
            ),
          ),
        ],
        verify: (_) {
          verify(
            () => updatePasswordUseCase.execute(
              currentPassword: currentPassword,
              newPassword: newPassword,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'sign out',
    () {
      setUp(
        () {
          when(() => signOutUseCase.execute()).thenAnswer((_) async => '');
        },
      );

      blocTest(
        'confirmed, should call use case responsible for signing out',
        build: () => createBloc(),
        setUp: () {
          when(
            () => profileDialogs.askForSignOutConfirmation(),
          ).thenAnswer((_) async => true);
        },
        act: (ProfileBloc bloc) {
          bloc.add(ProfileEventSignOut());
        },
        expect: () => [
          createState(status: const BlocStatusLoading()),
          createState(
            status: const BlocStatusComplete<ProfileInfoType>(
              info: ProfileInfoType.userHasBeenSignedOut,
            ),
          ),
        ],
        verify: (_) {
          verify(
            () => profileDialogs.askForSignOutConfirmation(),
          ).called(1);
          verify(() => signOutUseCase.execute()).called(1);
        },
      );

      blocTest(
        'cancelled, should not call use case responsible for signing out',
        build: () => createBloc(),
        setUp: () {
          when(
            () => profileDialogs.askForSignOutConfirmation(),
          ).thenAnswer((_) async => false);
        },
        act: (ProfileBloc bloc) {
          bloc.add(ProfileEventSignOut());
        },
        expect: () => [],
        verify: (_) {
          verify(
            () => profileDialogs.askForSignOutConfirmation(),
          ).called(1);
          verifyNever(() => signOutUseCase.execute());
        },
      );
    },
  );

  blocTest(
    'delete account, should call use case responsible for deleting logged user account',
    build: () => createBloc(),
    setUp: () {
      when(
        () => profileDialogs.askForAccountDeletionConfirmationPassword(),
      ).thenAnswer((_) async => 'password');
      when(
        () => deleteLoggedUserAccountUseCase.execute(password: 'password'),
      ).thenAnswer((_) async => '');
    },
    act: (ProfileBloc bloc) {
      bloc.add(ProfileEventDeleteAccount());
    },
    expect: () => [
      createState(status: const BlocStatusLoading()),
      createState(
        status: const BlocStatusComplete<ProfileInfoType>(
          info: ProfileInfoType.userAccountHasBeenDeleted,
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => profileDialogs.askForAccountDeletionConfirmationPassword(),
      ).called(1);
      verify(
        () => deleteLoggedUserAccountUseCase.execute(password: 'password'),
      ).called(1);
    },
  );

  blocTest(
    'delete account, should emit appropriate info if use case throws wrong password exception',
    build: () => createBloc(),
    setUp: () {
      when(
        () => profileDialogs.askForAccountDeletionConfirmationPassword(),
      ).thenAnswer((_) async => 'password');
      when(
        () => deleteLoggedUserAccountUseCase.execute(password: 'password'),
      ).thenThrow(AuthException.wrongPassword);
    },
    act: (ProfileBloc bloc) {
      bloc.add(ProfileEventDeleteAccount());
    },
    expect: () => [
      createState(status: const BlocStatusLoading()),
      createState(
        status: const BlocStatusError<ProfileErrorType>(
          errorType: ProfileErrorType.wrongPassword,
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => profileDialogs.askForAccountDeletionConfirmationPassword(),
      ).called(1);
      verify(
        () => deleteLoggedUserAccountUseCase.execute(password: 'password'),
      ).called(1);
    },
  );

  blocTest(
    'delete account, should not call use case responsible for deleting logged user account if user does not give password',
    build: () => createBloc(),
    setUp: () {
      when(
        () => profileDialogs.askForAccountDeletionConfirmationPassword(),
      ).thenAnswer((_) async => null);
      when(
        () => deleteLoggedUserAccountUseCase.execute(
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => '');
    },
    act: (ProfileBloc bloc) {
      bloc.add(ProfileEventDeleteAccount());
    },
    expect: () => [],
    verify: (_) {
      verify(
        () => profileDialogs.askForAccountDeletionConfirmationPassword(),
      ).called(1);
      verifyNever(
        () => deleteLoggedUserAccountUseCase.execute(
          password: any(named: 'password'),
        ),
      );
    },
  );
}
