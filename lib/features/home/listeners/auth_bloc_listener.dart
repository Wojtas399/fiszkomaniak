import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/dialogs/dialogs.dart';
import '../../../config/navigation.dart';

class AuthBlocListener extends BlocListener<AuthBloc, AuthState> {
  AuthBlocListener({super.key})
      : super(
          listener: (BuildContext context, AuthState state) {
            if (state is AuthStateLoading) {
              Dialogs.showLoadingDialog(context: context);
            } else if (state is AuthStateWrongPassword) {
              Dialogs.closeLoadingDialog(context);
              Dialogs.showDialogWithMessage(
                title: 'Niepoprawne hasło',
                message:
                    'Podano niepoprawne hasło. Spróbuj ponownie podając prawidłowe hasło.',
                context: context,
              );
            } else if (state is AuthStatePasswordChanged) {
              Dialogs.closeLoadingDialog(context);
              Dialogs.showSnackbarWithMessage('Pomyślnie zmieniono hasło.');
            } else if (state is AuthStateSignedOut) {
              Dialogs.closeLoadingDialog(context);
              context.read<Navigation>().pushReplacementToInitialHome();
            } else if (state is AuthStateError) {
              Dialogs.closeLoadingDialog(context);
              Dialogs.showErrorDialog(
                message: state.message,
                context: context,
              );
            }
          },
        );
}
