import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/achievements/get_remembered_flashcards_amount_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/achievements/load_remembered_flashcards_amount_use_case.dart';
import 'package:fiszkomaniak/domain/entities/user.dart';
import 'package:fiszkomaniak/domain/use_cases/auth/delete_logged_user_account_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/auth/sign_out_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/auth/update_password_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/user/get_user_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/user/get_days_streak_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/user/delete_avatar_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/user/update_avatar_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/user/update_user_username_use_case.dart';
import 'package:fiszkomaniak/exceptions/auth_exceptions.dart';
import 'package:fiszkomaniak/features/profile/bloc/profile_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

class MockLoadRememberedFlashcardsAmountUseCase extends Mock
    implements LoadRememberedFlashcardsAmountUseCase {}

class MockGetUserUseCase extends Mock implements GetUserUseCase {}

class MockGetRememberedFlashcardsAmountUseCase extends Mock
    implements GetRememberedFlashcardsAmountUseCase {}

class MockGetDaysStreakUseCase extends Mock implements GetDaysStreakUseCase {}

class MockUpdateUserUsernameUseCase extends Mock
    implements UpdateUserUsernameUseCase {}

class MockUpdatePasswordUseCase extends Mock implements UpdatePasswordUseCase {}

class MockUpdateAvatarUseCase extends Mock implements UpdateAvatarUseCase {}

class MockSignOutUseCase extends Mock implements SignOutUseCase {}

class MockDeleteLoggedUserAccountUseCase extends Mock
    implements DeleteLoggedUserAccountUseCase {}

class MockDeleteAvatarUseCase extends Mock implements DeleteAvatarUseCase {}

void main() {
  final loadRememberedFlashcardsAmountUseCase =
      MockLoadRememberedFlashcardsAmountUseCase();
  final getUserUseCase = MockGetUserUseCase();
  final getRememberedFlashcardsAmountUseCase =
      MockGetRememberedFlashcardsAmountUseCase();
  final getDaysStreakUseCase = MockGetDaysStreakUseCase();
  final updateUserUsernameUseCase = MockUpdateUserUsernameUseCase();
  final updatePasswordUseCase = MockUpdatePasswordUseCase();
  final updateAvatarUseCase = MockUpdateAvatarUseCase();
  final signOutUseCase = MockSignOutUseCase();
  final deleteLoggedUserAccountUseCase = MockDeleteLoggedUserAccountUseCase();
  final deleteAvatarUseCase = MockDeleteAvatarUseCase();

  ProfileBloc createBloc({
    BlocStatus status = const BlocStatusInitial(),
    User? user,
    int daysStreak = 0,
    int amountOfRememberedFlashcards = 0,
  }) {
    return ProfileBloc(
      loadRememberedFlashcardsAmountUseCase:
          loadRememberedFlashcardsAmountUseCase,
      getUserUseCase: getUserUseCase,
      getRememberedFlashcardsAmountUseCase:
          getRememberedFlashcardsAmountUseCase,
      getDaysStreakUseCase: getDaysStreakUseCase,
      updateUserUsernameUseCase: updateUserUsernameUseCase,
      updatePasswordUseCase: updatePasswordUseCase,
      updateAvatarUseCase: updateAvatarUseCase,
      signOutUseCase: signOutUseCase,
      deleteLoggedUserAccountUseCase: deleteLoggedUserAccountUseCase,
      deleteAvatarUseCase: deleteAvatarUseCase,
      status: status,
      user: user,
      daysStreak: daysStreak,
      amountOfRememberedFlashcards: amountOfRememberedFlashcards,
    );
  }

  ProfileState createState({
    BlocStatus status = const BlocStatusInProgress(),
    User? user,
    int daysStreak = 0,
    int amountOfRememberedFlashcards = 0,
  }) {
    return ProfileState(
      status: status,
      user: user,
      daysStreak: daysStreak,
      amountOfRememberedFlashcards: amountOfRememberedFlashcards,
    );
  }

  tearDown(() {
    reset(loadRememberedFlashcardsAmountUseCase);
    reset(getUserUseCase);
    reset(getRememberedFlashcardsAmountUseCase);
    reset(getDaysStreakUseCase);
    reset(updateUserUsernameUseCase);
    reset(updatePasswordUseCase);
    reset(updateAvatarUseCase);
    reset(signOutUseCase);
    reset(deleteLoggedUserAccountUseCase);
    reset(deleteAvatarUseCase);
  });

  group(
    'initialize',
    () {
      final User user = createUser(username: 'username');
      const int rememberedFlashcardsAmount = 200;
      const int daysStreak = 6;

      blocTest(
        'should set user, remembered flashcards amount and days streak listener',
        build: () => createBloc(),
        setUp: () {
          when(
            () => loadRememberedFlashcardsAmountUseCase.execute(),
          ).thenAnswer((_) async => '');
          when(
            () => getUserUseCase.execute(),
          ).thenAnswer((_) => Stream.value(user));
          when(
            () => getRememberedFlashcardsAmountUseCase.execute(),
          ).thenAnswer((_) => Stream.value(rememberedFlashcardsAmount));
          when(
            () => getDaysStreakUseCase.execute(),
          ).thenAnswer((_) => Stream.value(daysStreak));
        },
        act: (ProfileBloc bloc) {
          bloc.add(ProfileEventInitialize());
        },
        expect: () => [
          createState(
            user: user,
            amountOfRememberedFlashcards: rememberedFlashcardsAmount,
            daysStreak: daysStreak,
          ),
        ],
        verify: (_) {
          verify(
            () => loadRememberedFlashcardsAmountUseCase.execute(),
          ).called(1);
          verify(
            () => getUserUseCase.execute(),
          ).called(1);
          verify(
            () => getRememberedFlashcardsAmountUseCase.execute(),
          ).called(1);
          verify(
            () => getDaysStreakUseCase.execute(),
          ).called(1);
        },
      );
    },
  );

  group(
    'listened params updated',
    () {
      final User user = createUser(username: 'username');
      const int rememberedFlashcardsAmount = 200;
      const int daysStreak = 6;

      blocTest(
        'should update user, remembered flashcards amount and days streak in state',
        build: () => createBloc(),
        act: (ProfileBloc bloc) {
          bloc.add(
            ProfileEventListenedParamsUpdated(
              params: ProfileStateListenedParams(
                user: user,
                amountOfRememberedFlashcards: rememberedFlashcardsAmount,
                daysStreak: daysStreak,
              ),
            ),
          );
        },
        expect: () => [
          createState(
            user: user,
            amountOfRememberedFlashcards: rememberedFlashcardsAmount,
            daysStreak: daysStreak,
          ),
        ],
      );
    },
  );

  blocTest(
    'change avatar, should call use case responsible for updating avatar',
    build: () => createBloc(),
    setUp: () {
      when(
        () => updateAvatarUseCase.execute(imagePath: 'path'),
      ).thenAnswer((_) async => '');
    },
    act: (ProfileBloc bloc) {
      bloc.add(
        ProfileEventChangeAvatar(imagePath: 'path'),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusComplete<ProfileInfo>(
          info: ProfileInfo.avatarHasBeenUpdated,
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => updateAvatarUseCase.execute(imagePath: 'path'),
      ).called(1);
    },
  );

  blocTest(
    'delete avatar, should call use case responsible for deleting avatar',
    build: () => createBloc(),
    setUp: () {
      when(
        () => deleteAvatarUseCase.execute(),
      ).thenAnswer((_) async => '');
    },
    act: (ProfileBloc bloc) {
      bloc.add(
        ProfileEventDeleteAvatar(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusComplete<ProfileInfo>(
          info: ProfileInfo.avatarHasBeenDeleted,
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => deleteAvatarUseCase.execute(),
      ).called(1);
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
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusComplete<ProfileInfo>(
          info: ProfileInfo.usernameHasBeenUpdated,
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
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusComplete<ProfileInfo>(
              info: ProfileInfo.passwordHasBeenUpdated,
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
            status: const BlocStatusError<ProfileError>(
              error: ProfileError.wrongPassword,
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

  blocTest(
    'sign out, should call use case responsible for signing out',
    build: () => createBloc(),
    setUp: () {
      when(
        () => signOutUseCase.execute(),
      ).thenAnswer((_) async => '');
    },
    act: (ProfileBloc bloc) {
      bloc.add(
        ProfileEventSignOut(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusComplete<ProfileInfo>(
          info: ProfileInfo.userHasBeenSignedOut,
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => signOutUseCase.execute(),
      ).called(1);
    },
  );

  blocTest(
    'delete account, should call use case responsible for deleting logged user account',
    build: () => createBloc(),
    setUp: () {
      when(
        () => deleteLoggedUserAccountUseCase.execute(password: 'password'),
      ).thenAnswer((_) async => '');
    },
    act: (ProfileBloc bloc) {
      bloc.add(
        ProfileEventDeleteAccount(password: 'password'),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusComplete<ProfileInfo>(
          info: ProfileInfo.userAccountHasBeenDeleted,
        ),
      ),
    ],
    verify: (_) {
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
        () => deleteLoggedUserAccountUseCase.execute(password: 'password'),
      ).thenThrow(AuthException.wrongPassword);
    },
    act: (ProfileBloc bloc) {
      bloc.add(
        ProfileEventDeleteAccount(password: 'password'),
      );
    },
    expect: () => [
      createState(status: const BlocStatusLoading()),
      createState(
        status: const BlocStatusError<ProfileError>(
          error: ProfileError.wrongPassword,
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => deleteLoggedUserAccountUseCase.execute(password: 'password'),
      ).called(1);
    },
  );
}
