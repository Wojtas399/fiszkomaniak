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
            void closeLoadingDialog() {
              Navigator.of(context, rootNavigator: true).pop();
            }

            if (status is UserStatusLoading) {
              Dialogs.showLoadingDialog();
            } else if (status is UserStatusNewAvatarSaved) {
              closeLoadingDialog();
              Dialogs.showSnackbarWithMessage(
                'Pomyślnie zapisano nowe zdjęcie profilowe',
              );
            } else if (status is UserStatusAvatarRemoved) {
              closeLoadingDialog();
              Dialogs.showSnackbarWithMessage(
                'Pomyślnie usunięto zdjęcie profilowe',
              );
            } else if (status is UserStatusUsernameUpdated) {
              closeLoadingDialog();
              Dialogs.showSnackbarWithMessage(
                'Pomyślnie zmieniono nazwę użytkownika',
              );
            } else if (status is UserStatusNewRememberedFlashcardsSaved) {
              closeLoadingDialog();
              Dialogs.showSnackbarWithMessage('Pomyślnie zapisano zmiany');
            } else if (status is UserStatusError) {
              closeLoadingDialog();
              Dialogs.showErrorDialog(message: status.message);
            }
          },
        );
}
