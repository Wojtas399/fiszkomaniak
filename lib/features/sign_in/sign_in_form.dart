import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/features/sign_in/bloc/sign_in_bloc.dart';
import 'package:fiszkomaniak/features/sign_in/components/sign_in_submit_button.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/sign_in_state.dart';
import 'components/sign_in_alternative_options.dart';
import 'components/sign_in_inputs.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignInBloc(authBloc: context.read<AuthBloc>()),
      child: _FormStatusListener(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            const SizedBox(height: 24),
            SignInInputs(),
            const SizedBox(height: 8),
            const SignInSubmitButton(),
            const SizedBox(height: 16),
            const AlternativeOptions(),
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
      'Zaloguj się',
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

  const _FormStatusListener({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        final httpStatus = state.httpStatus;
        if (httpStatus is HttpStatusSubmitting) {
          Dialogs.showLoadingDialog(context: context);
        } else if (httpStatus is HttpStatusSuccess) {
          Navigator.pop(context);
          Navigation.pushReplacementToHome();
        } else if (httpStatus is HttpStatusFailure) {
          Navigator.pop(context);
          Dialogs.showDialogWithMessage(
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
