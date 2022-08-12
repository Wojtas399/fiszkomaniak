import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/auth/send_password_reset_email_use_case.dart';
import '../../../interfaces/auth_interface.dart';
import '../../models/bloc_status.dart';
import '../../providers/dialogs_provider.dart';
import '../../validators/email_validator.dart';
import 'bloc/reset_password_bloc.dart';
import 'reset_password_content.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ResetPasswordBlocProvider(
      child: _ResetPasswordStateListener(
        child: ResetPasswordContent(),
      ),
    );
  }
}

class _ResetPasswordBlocProvider extends StatelessWidget {
  final Widget child;

  const _ResetPasswordBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ResetPasswordBloc(
        sendPasswordResetEmailUseCase: SendPasswordResetEmailUseCase(
          authInterface: context.read<AuthInterface>(),
        ),
        emailValidator: EmailValidator(),
      ),
      child: child,
    );
  }
}

class _ResetPasswordStateListener extends StatelessWidget {
  final Widget child;

  const _ResetPasswordStateListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordBloc, ResetPasswordState>(
      listener: (BuildContext context, ResetPasswordState state) {
        final BlocStatus blocStatus = state.status;
        if (blocStatus is BlocStatusLoading) {
          DialogsProvider.showLoadingDialog(context: context);
        } else if (blocStatus is BlocStatusComplete) {
          DialogsProvider.closeLoadingDialog(context);
          final ResetPasswordInfo? info = blocStatus.info;
          if (info != null) {
            _manageInfo(info, context);
          }
        } else if (blocStatus is BlocStatusError) {
          DialogsProvider.closeLoadingDialog(context);
          final ResetPasswordError? error = blocStatus.error;
          if (error != null) {
            _manageError(error, context);
          }
        }
      },
      child: child,
    );
  }

  void _manageInfo(ResetPasswordInfo info, BuildContext context) {
    switch (info) {
      case ResetPasswordInfo.emailHasBeenSent:
        DialogsProvider.showDialogWithMessage(
          context: context,
          title: 'Email wysłany',
          message:
              'Pomyślnie wysłano wiadomość email z instrukcją dotyczącą resetowania hasła',
        );
        break;
    }
  }

  void _manageError(ResetPasswordError error, BuildContext context) {
    switch (error) {
      case ResetPasswordError.invalidEmail:
        DialogsProvider.showDialogWithMessage(
          context: context,
          title: 'Niepoprawny adres email',
          message: 'Podano niepoprawny adres email do wysłania wiadomości',
        );
        break;
      case ResetPasswordError.userNotFound:
        DialogsProvider.showDialogWithMessage(
          context: context,
          title: 'Brak użytkownika',
          message:
              'Nie znaleziono zarejestrowanego użytkownika o podanym adresie email',
        );
        break;
    }
  }
}
