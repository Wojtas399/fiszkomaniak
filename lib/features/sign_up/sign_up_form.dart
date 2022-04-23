import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_state.dart';
import 'package:fiszkomaniak/features/sign_up/components/sign_up_alternative_option.dart';
import 'package:fiszkomaniak/features/sign_up/components/sign_up_inputs.dart';
import 'package:fiszkomaniak/features/sign_up/components/sign_up_submit_button.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpBloc(authBloc: context.read<AuthBloc>()),
      child: _FormStatusListener(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            const SizedBox(height: 24),
            SignUpInputs(),
            const SizedBox(height: 8),
            const SignUpSubmitButton(),
            const SizedBox(height: 16),
            const SignUpAlternativeOption(),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Zarejestruj się',
      style: TextStyle(
        color: Colors.black,
        fontSize: 34,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _FormStatusListener extends StatelessWidget {
  final Widget child;

  const _FormStatusListener({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        final Dialogs dialogs = Dialogs();
        final httpStatus = state.httpStatus;
        if (httpStatus is HttpStatusSubmitting) {
          dialogs.showLoadingDialog(
            context: context,
            loadingText: 'Rejestrowanie...',
          );
        } else if (httpStatus is HttpStatusSuccess) {
          Navigator.pop(context);
          context.read<Navigation>().pushReplacementToHome(context);
        } else if (httpStatus is HttpStatusFailure) {
          Navigator.pop(context);
          dialogs.showDialogWithMessage(
            context: context,
            title: 'Wystąpił błąd',
            message: httpStatus.message,
          );
        }
      },
      child: child,
    );
  }
}
