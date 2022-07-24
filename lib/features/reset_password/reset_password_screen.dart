import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/auth/send_password_reset_email_use_case.dart';
import '../../../interfaces/auth_interface.dart';
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
          Dialogs.showLoadingDialog(context: context);
        } else if (blocStatus is BlocStatusComplete) {
          Dialogs.closeLoadingDialog(context);
          final ResetPasswordInfoType? infoType = blocStatus.info;
          if (infoType != null) {
            _manageInfoType(infoType, context);
          }
        } else if (blocStatus is BlocStatusError) {
          Dialogs.closeLoadingDialog(context);
          final ResetPasswordErrorType? errorType = blocStatus.errorType;
          if (errorType != null) {
            _manageErrorType(errorType, context);
          }
        }
      },
      child: child,
    );
  }

  void _manageInfoType(ResetPasswordInfoType infoType, BuildContext context) {
    switch (infoType) {
      case ResetPasswordInfoType.emailHasBeenSent:
        Dialogs.showDialogWithMessage(
          context: context,
          title: 'Email wysłany',
          message:
              'Pomyślnie wysłano wiadomość email z instrukcją dotyczącą resetowania hasła',
        );
        break;
    }
  }

  void _manageErrorType(
    ResetPasswordErrorType errorType,
    BuildContext context,
  ) {
    switch (errorType) {
      case ResetPasswordErrorType.invalidEmail:
        Dialogs.showDialogWithMessage(
          context: context,
          title: 'Niepoprawny adres email',
          message: 'Podano niepoprawny adres email do wysłania wiadomości',
        );
        break;
      case ResetPasswordErrorType.userNotFound:
        Dialogs.showDialogWithMessage(
          context: context,
          title: 'Brak użytkownika',
          message:
              'Nie znaleziono zarejestrowanego użytkownika o podanym adresie email',
        );
        break;
    }
  }
}
