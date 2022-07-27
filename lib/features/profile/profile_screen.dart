import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/dialogs/dialogs.dart';
import '../../config/navigation.dart';
import '../../domain/use_cases/auth/sign_out_use_case.dart';
import '../../domain/use_cases/auth/update_password_use_case.dart';
import '../../domain/use_cases/user/get_user_use_case.dart';
import '../../domain/use_cases/auth/delete_logged_user_account_use_case.dart';
import '../../domain/use_cases/user/update_user_username_use_case.dart';
import '../../domain/use_cases/user/delete_avatar_use_case.dart';
import '../../domain/use_cases/user/update_avatar_use_case.dart';
import '../../interfaces/auth_interface.dart';
import '../../interfaces/user_interface.dart';
import '../../models/bloc_status.dart';
import 'bloc/profile_bloc.dart';
import 'components/profile_content.dart';
import 'profile_dialogs.dart';

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
        updateUserUsernameUseCase: UpdateUserUsernameUseCase(
          userInterface: context.read<UserInterface>(),
        ),
        updatePasswordUseCase: UpdatePasswordUseCase(
          authInterface: context.read<AuthInterface>(),
        ),
        signOutUseCase: SignOutUseCase(
          authInterface: context.read<AuthInterface>(),
          userInterface: context.read<UserInterface>(),
        ),
        deleteLoggedUserAccountUseCase: DeleteLoggedUserAccountUseCase(
          userInterface: context.read<UserInterface>(),
          authInterface: context.read<AuthInterface>(),
        ),
        getUserUseCase: GetUserUseCase(
          userInterface: context.read<UserInterface>(),
        ),
        updateAvatarUseCase: UpdateAvatarUseCase(
          userInterface: context.read<UserInterface>(),
        ),
        deleteAvatarUseCase: DeleteAvatarUseCase(
          userInterface: context.read<UserInterface>(),
        ),
        // achievementsBloc: context.read<AchievementsBloc>(),
        profileDialogs: ProfileDialogs(),
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
          Dialogs.showLoadingDialog();
        } else if (blocStatus is BlocStatusComplete) {
          Dialogs.closeLoadingDialog(context);
          final ProfileInfoType? infoType = blocStatus.info;
          if (infoType != null) {
            _manageInfoType(infoType, context);
          }
        } else if (blocStatus is BlocStatusError) {
          Dialogs.closeLoadingDialog(context);
          final ProfileErrorType? errorType = blocStatus.errorType;
          if (errorType != null) {
            _manageErrorType(errorType);
          }
        }
      },
      child: child,
    );
  }

  void _manageInfoType(ProfileInfoType infoType, BuildContext context) {
    switch (infoType) {
      case ProfileInfoType.avatarHasBeenUpdated:
        Dialogs.showSnackbarWithMessage('Pomyślnie zmieniono avatar');
        break;
      case ProfileInfoType.avatarHasBeenDeleted:
        Dialogs.showSnackbarWithMessage('Pomyślnie usunięto avatar');
        break;
      case ProfileInfoType.usernameHasBeenUpdated:
        Dialogs.showSnackbarWithMessage(
          'Pomyślnie zmieniono nazwę użytkownika',
        );
        break;
      case ProfileInfoType.passwordHasBeenUpdated:
        Dialogs.showSnackbarWithMessage('Pomyślnie zmieniono hasło');
        break;
      case ProfileInfoType.userHasBeenSignedOut:
        context.read<Navigation>().pushReplacementToInitialHome();
        break;
      case ProfileInfoType.userAccountHasBeenDeleted:
        context.read<Navigation>().pushReplacementToInitialHome();
        Dialogs.showDialogWithMessage(
          title: 'Konto usunięte',
          message:
              'Twoje konto zostało trwale usunięte. Jeśli chcesz ponownie skorzystać z aplikacji, załóż nowe konto.',
        );
        break;
    }
  }

  void _manageErrorType(ProfileErrorType errorType) {
    switch (errorType) {
      case ProfileErrorType.wrongPassword:
        Dialogs.showDialogWithMessage(
          title: 'Niepoprawne hasło',
          message:
              'Operacja nie powiodła się, ponieważ podano niepoprawne obecne hasło',
        );
        break;
    }
  }
}
