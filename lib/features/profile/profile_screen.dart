import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/navigation.dart';
import '../../providers/dialogs_provider.dart';
import '../../domain/use_cases/achievements/get_remembered_flashcards_amount_use_case.dart';
import '../../domain/use_cases/achievements/load_remembered_flashcards_amount_use_case.dart';
import '../../domain/use_cases/auth/sign_out_use_case.dart';
import '../../domain/use_cases/auth/update_password_use_case.dart';
import '../../domain/use_cases/user/get_user_use_case.dart';
import '../../domain/use_cases/user/get_days_streak_use_case.dart';
import '../../domain/use_cases/auth/delete_logged_user_account_use_case.dart';
import '../../domain/use_cases/user/update_user_username_use_case.dart';
import '../../domain/use_cases/user/delete_avatar_use_case.dart';
import '../../domain/use_cases/user/update_avatar_use_case.dart';
import '../../interfaces/achievements_interface.dart';
import '../../interfaces/auth_interface.dart';
import '../../interfaces/user_interface.dart';
import '../../interfaces/settings_interface.dart';
import '../../models/bloc_status.dart';
import 'bloc/profile_bloc.dart';
import 'components/profile_content.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProfileBlocProvider(
      child: _ProfileBlocListener(
        child: ProfileContent(),
      ),
    );
  }
}

class _ProfileBlocProvider extends StatelessWidget {
  final Widget child;

  const _ProfileBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ProfileBloc(
        loadRememberedFlashcardsAmountUseCase:
            LoadRememberedFlashcardsAmountUseCase(
          achievementsInterface: context.read<AchievementsInterface>(),
        ),
        getUserUseCase: GetUserUseCase(
          userInterface: context.read<UserInterface>(),
        ),
        getRememberedFlashcardsAmountUseCase:
            GetRememberedFlashcardsAmountUseCase(
          achievementsInterface: context.read<AchievementsInterface>(),
        ),
        getDaysStreakUseCase: GetDaysStreakUseCase(
          userInterface: context.read<UserInterface>(),
        ),
        updateUserUsernameUseCase: UpdateUserUsernameUseCase(
          userInterface: context.read<UserInterface>(),
        ),
        updatePasswordUseCase: UpdatePasswordUseCase(
          authInterface: context.read<AuthInterface>(),
        ),
        updateAvatarUseCase: UpdateAvatarUseCase(
          userInterface: context.read<UserInterface>(),
        ),
        signOutUseCase: SignOutUseCase(
          authInterface: context.read<AuthInterface>(),
          userInterface: context.read<UserInterface>(),
          achievementsInterface: context.read<AchievementsInterface>(),
          settingsInterface: context.read<SettingsInterface>(),
        ),
        deleteLoggedUserAccountUseCase: DeleteLoggedUserAccountUseCase(
          userInterface: context.read<UserInterface>(),
          authInterface: context.read<AuthInterface>(),
          achievementsInterface: context.read<AchievementsInterface>(),
          settingsInterface: context.read<SettingsInterface>(),
        ),
        deleteAvatarUseCase: DeleteAvatarUseCase(
          userInterface: context.read<UserInterface>(),
        ),
      )..add(ProfileEventInitialize()),
      child: child,
    );
  }
}

class _ProfileBlocListener extends StatelessWidget {
  final Widget child;

  const _ProfileBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (BuildContext context, ProfileState state) {
        final BlocStatus blocStatus = state.status;
        if (blocStatus is BlocStatusLoading) {
          DialogsProvider.showLoadingDialog();
        } else if (blocStatus is BlocStatusComplete) {
          DialogsProvider.closeLoadingDialog(context);
          final ProfileInfo? info = blocStatus.info;
          if (info != null) {
            _manageInfo(info, context);
          }
        } else if (blocStatus is BlocStatusError) {
          DialogsProvider.closeLoadingDialog(context);
          final ProfileError? error = blocStatus.error;
          if (error != null) {
            _manageError(error);
          }
        }
      },
      child: child,
    );
  }

  void _manageInfo(ProfileInfo info, BuildContext context) {
    switch (info) {
      case ProfileInfo.avatarHasBeenUpdated:
        DialogsProvider.showSnackbarWithMessage('Pomyślnie zmieniono avatar');
        break;
      case ProfileInfo.avatarHasBeenDeleted:
        DialogsProvider.showSnackbarWithMessage('Pomyślnie usunięto avatar');
        break;
      case ProfileInfo.usernameHasBeenUpdated:
        DialogsProvider.showSnackbarWithMessage(
          'Pomyślnie zmieniono nazwę użytkownika',
        );
        break;
      case ProfileInfo.passwordHasBeenUpdated:
        DialogsProvider.showSnackbarWithMessage('Pomyślnie zmieniono hasło');
        break;
      case ProfileInfo.userHasBeenSignedOut:
        Navigation.pushReplacementToInitialHome();
        break;
      case ProfileInfo.userAccountHasBeenDeleted:
        Navigation.pushReplacementToInitialHome();
        DialogsProvider.showDialogWithMessage(
          title: 'Konto usunięte',
          message:
              'Twoje konto zostało trwale usunięte. Jeśli chcesz ponownie skorzystać z aplikacji, załóż nowe konto.',
        );
        break;
    }
  }

  void _manageError(ProfileError errorType) {
    switch (errorType) {
      case ProfileError.wrongPassword:
        DialogsProvider.showDialogWithMessage(
          title: 'Niepoprawne hasło',
          message:
              'Operacja nie powiodła się, ponieważ podano niepoprawne obecne hasło',
        );
        break;
    }
  }
}
