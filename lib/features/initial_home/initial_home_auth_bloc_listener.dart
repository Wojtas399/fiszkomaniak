import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/dialogs/dialogs.dart';
import '../../config/navigation.dart';
import '../../core/auth/auth_bloc.dart';

class InitialHomeAuthBlocListener extends StatelessWidget {
  final Widget child;

  const InitialHomeAuthBlocListener({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) {
        void closeLoadingDialog() {
          Navigator.of(context, rootNavigator: true).pop();
        }

        if (state is AuthStateLoading) {
          Dialogs.showLoadingDialog(context: context);
        } else if (state is AuthStateSignedIn) {
          context.read<Navigation>().pushReplacementToHome(context);
        } else if (state is AuthStatePasswordResetEmailSent) {
          closeLoadingDialog();
          Navigator.of(context).pop();
          Dialogs.showDialogWithMessage(
            title: 'Udało się!',
            message:
                'Pomyślnie wysłano wiadomość email z linkiem do zresetowania hasła.',
            context: context,
          );
        } else if (state is AuthStateUserNotFound) {
          closeLoadingDialog();
          Dialogs.showDialogWithMessage(
            title: 'Brak użytkownika',
            message: 'Nie znaleziono użytkownika o podanym adresie email.',
            context: context,
          );
        } else if (state is AuthStateWrongPassword) {
          closeLoadingDialog();
          Dialogs.showDialogWithMessage(
            title: 'Niepoprawne hasło',
            message: 'Podano niepoprawne hasło dla tego użytkownika.',
            context: context,
          );
        } else if (state is AuthStateInvalidEmail) {
          closeLoadingDialog();
          Dialogs.showDialogWithMessage(
            title: 'Niepoprawny adres email',
            message: 'Wprowadzono niepoprawny adres email.',
            context: context,
          );
        } else if (state is AuthStateEmailAlreadyInUse) {
          closeLoadingDialog();
          Dialogs.showDialogWithMessage(
            title: 'Zajęty adres email',
            message:
                'Podany adres email jest już zajęty przez innego użytkownika.',
            context: context,
          );
        } else if (state is AuthStateError) {
          closeLoadingDialog();
          Dialogs.showErrorDialog(
            message: state.message,
            context: context,
          );
        }
      },
      child: child,
    );
  }
}
