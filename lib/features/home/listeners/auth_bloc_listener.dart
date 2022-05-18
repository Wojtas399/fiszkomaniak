import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/dialogs/dialogs.dart';
import '../../../config/navigation.dart';

class AuthBlocListener extends BlocListener<AuthBloc, AuthState> {
  AuthBlocListener({super.key})
      : super(
          listener: (BuildContext context, AuthState state) {
            void closeLoadingDialog() {
              Navigator.of(context, rootNavigator: true).pop();
            }

            if (state is AuthStateLoading) {
              Dialogs.showLoadingDialog(context: context);
            } else if (state is AuthStateWrongPassword) {
              closeLoadingDialog();
              Dialogs.showDialogWithMessage(
                title: 'Niepoprawne hasło',
                message:
                    'Podano niepoprawne hasło. Spróbuj ponownie podając prawidłowe hasło.',
                context: context,
              );
            } else if (state is AuthStatePasswordChanged) {
              closeLoadingDialog();
              Dialogs.showSnackbarWithMessage('Pomyślnie zmieniono hasło.');
            } else if (state is AuthStateSignedOut) {
              closeLoadingDialog();
              context.read<Navigation>().pushReplacementToInitialHome();
            } else if (state is AuthStateError) {
              closeLoadingDialog();
              Dialogs.showErrorDialog(
                message: state.message,
                context: context,
              );
            }
          },
        );
}
