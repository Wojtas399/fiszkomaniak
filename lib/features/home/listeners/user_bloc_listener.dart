import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/user/user_bloc.dart';

class UserBlocListener extends BlocListener<UserBloc, UserState> {
  UserBlocListener({Key? key})
      : super(
          key: key,
          listener: (BuildContext context, UserState state) {
            final UserStatus status = state.status;
            if (status is UserStatusLoading) {
              Dialogs.showLoadingDialog();
            } else if (status is UserStatusNewAvatarSaved) {
              Dialogs.closeLoadingDialog(context);
              Dialogs.showSnackbarWithMessage(
                'Pomyślnie zapisano nowe zdjęcie profilowe',
              );
            } else if (status is UserStatusAvatarRemoved) {
              Dialogs.closeLoadingDialog(context);
              Dialogs.showSnackbarWithMessage(
                'Pomyślnie usunięto zdjęcie profilowe',
              );
            } else if (status is UserStatusUsernameUpdated) {
              Dialogs.closeLoadingDialog(context);
              Dialogs.showSnackbarWithMessage(
                'Pomyślnie zmieniono nazwę użytkownika',
              );
            } else if (status is UserStatusNewRememberedFlashcardsSaved) {
              Dialogs.closeLoadingDialog(context);
              Dialogs.showSnackbarWithMessage('Pomyślnie zapisano zmiany');
            } else if (status is UserStatusError) {
              Dialogs.closeLoadingDialog(context);
              Dialogs.showErrorDialog(message: status.message);
            }
          },
        );
}
