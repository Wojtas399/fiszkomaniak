import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/achievements/get_all_flashcards_amount_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/achievements/load_all_flashcards_amount_use_case.dart';
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
import 'package:fiszkomaniak/features/profile/profile_dialogs.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

class MockLoadAllFlashcardsAmountUseCase extends Mock
    implements LoadAllFlashcardsAmountUseCase {}

class MockGetUserUseCase extends Mock implements GetUserUseCase {}

class MockGetAllFlashcardsAmountUseCase extends Mock
    implements GetAllFlashcardsAmountUseCase {}

class MockGetDaysStreakUseCase extends Mock implements GetDaysStreakUseCase {}

class MockUpdateUserUsernameUseCase extends Mock
    implements UpdateUserUsernameUseCase {}

class MockUpdatePasswordUseCase extends Mock implements UpdatePasswordUseCase {}

class MockUpdateAvatarUseCase extends Mock implements UpdateAvatarUseCase {}

class MockSignOutUseCase extends Mock implements SignOutUseCase {}

class MockDeleteLoggedUserAccountUseCase extends Mock
    implements DeleteLoggedUserAccountUseCase {}

class MockDeleteAvatarUseCase extends Mock implements DeleteAvatarUseCase {}

class MockProfileDialogs extends Mock implements ProfileDialogs {}

void main() {
  final loadAllFlashcardsAmountUseCase = MockLoadAllFlashcardsAmountUseCase();
  final getUserUseCase = MockGetUserUseCase();
  final getAllFlashcardsAmountUseCase = MockGetAllFlashcardsAmountUseCase();
  final getDaysStreakUseCase = MockGetDaysStreakUseCase();
  final updateUserUsernameUseCase = MockUpdateUserUsernameUseCase();
  final updatePasswordUseCase = MockUpdatePasswordUseCase();
  final updateAvatarUseCase = MockUpdateAvatarUseCase();
  final signOutUseCase = MockSignOutUseCase();
  final deleteLoggedUserAccountUseCase = MockDeleteLoggedUserAccountUseCase();
  final deleteAvatarUseCase = MockDeleteAvatarUseCase();
  final profileDialogs = MockProfileDialogs();

  ProfileBloc createBloc({
    BlocStatus status = const BlocStatusInitial(),
    User? user,
    int daysStreak = 0,
    int amountOfAllFlashcards = 0,
  }) {
    return ProfileBloc(
      loadAllFlashcardsAmountUseCase: loadAllFlashcardsAmountUseCase,
      getUserUseCase: getUserUseCase,
      getAllFlashcardsAmountUseCase: getAllFlashcardsAmountUseCase,
      getDaysStreakUseCase: getDaysStreakUseCase,
      updateUserUsernameUseCase: updateUserUsernameUseCase,
      updatePasswordUseCase: updatePasswordUseCase,
      updateAvatarUseCase: updateAvatarUseCase,
      signOutUseCase: signOutUseCase,
      deleteLoggedUserAccountUseCase: deleteLoggedUserAccountUseCase,
      deleteAvatarUseCase: deleteAvatarUseCase,
      profileDialogs: profileDialogs,
      status: status,
      user: user,
      daysStreak: daysStreak,
      amountOfAllFlashcards: amountOfAllFlashcards,
    );
  }

  ProfileState createState({
    BlocStatus status = const BlocStatusComplete(),
    User? user,
    int daysStreak = 0,
    int amountOfAllFlashcards = 0,
  }) {
    return ProfileState(
      status: status,
      user: user,
      daysStreak: daysStreak,
      amountOfAllFlashcards: amountOfAllFlashcards,
    );
  }

  tearDown(() {
    reset(loadAllFlashcardsAmountUseCase);
    reset(getUserUseCase);
    reset(getAllFlashcardsAmountUseCase);
    reset(getDaysStreakUseCase);
    reset(updateUserUsernameUseCase);
    reset(updatePasswordUseCase);
    reset(updateAvatarUseCase);
    reset(signOutUseCase);
    reset(deleteLoggedUserAccountUseCase);
    reset(deleteAvatarUseCase);
    reset(profileDialogs);
  });

  group(
    'initialize',
    () {
      final User user = createUser(username: 'username');
      const int flashcardsAmount = 200;
      const int daysStreak = 6;

      blocTest(
        'should set user, all flashcards amount and days streak listener',
        build: () => createBloc(),
        setUp: () {
          when(
            () => loadAllFlashcardsAmountUseCase.execute(),
          ).thenAnswer((_) async => '');
          when(
            () => getUserUseCase.execute(),
          ).thenAnswer((_) => Stream.value(user));
          when(
            () => getAllFlashcardsAmountUseCase.execute(),
          ).thenAnswer((_) => Stream.value(flashcardsAmount));
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
            amountOfAllFlashcards: flashcardsAmount,
            daysStreak: daysStreak,
          ),
        ],
        verify: (_) {
          verify(() => loadAllFlashcardsAmountUseCase.execute()).called(1);
          verify(() => getUserUseCase.execute()).called(1);
          verify(() => getAllFlashcardsAmountUseCase.execute()).called(1);
          verify(() => getDaysStreakUseCase.execute()).called(1);
        },
      );
    },
  );

  group(
    'listened params updated',
    () {
      final User user = createUser(username: 'username');
      const int allFlashcardsAmount = 200;
      const int daysStreak = 6;

      blocTest(
        'should update user, all flashcards amount and days streak in state',
        build: () => createBloc(),
        act: (ProfileBloc bloc) {
          bloc.add(
            ProfileEventListenedParamsUpdated(
              params: ProfileStateListenedParams(
                user: user,
                allFlashcardsAmount: allFlashcardsAmount,
                daysStreak: daysStreak,
              ),
            ),
          );
        },
        expect: () => [
          createState(
            user: user,
            amountOfAllFlashcards: allFlashcardsAmount,
            daysStreak: daysStreak,
          ),
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
