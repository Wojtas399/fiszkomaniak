import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/features/reset_password/bloc/reset_password_bloc.dart';
import 'package:fiszkomaniak/features/reset_password/components/reset_password_app_bar.dart';
import 'package:fiszkomaniak/features/reset_password/components/reset_password_submit_button.dart';
import 'package:fiszkomaniak/features/reset_password/components/reset_password_text_and_input.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../utils/utils.dart';
import 'bloc/reset_password_state.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPasswordBloc(
        authBloc: Provider.of<AuthBloc>(context),
      ),
      child: _StatusListener(
        child: Scaffold(
          appBar: const ResetPasswordAppBar(),
          body: SafeArea(
            child: _LostFocusAreaWithPaddings(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  ResetPasswordTextAndInput(),
                  ResetPasswordSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusListener extends StatelessWidget {
  final Widget child;

  const _StatusListener({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordBloc, ResetPasswordState>(
      listener: (context, state) async {
        HttpStatus httpStatus = state.httpStatus;
        if (httpStatus is HttpStatusSubmitting) {
          Dialogs.showLoadingDialog(context: context);
        } else if (httpStatus is HttpStatusSuccess) {
          Navigator.pop(context);
          await Dialogs.showDialogWithMessage(
            context: context,
            title: 'Udało się!',
            message: 'Pomyślnie wysłaliśmy wiadomość na twój adres e-mail.',
          );
          Navigator.pop(context);
        } else if (httpStatus is HttpStatusFailure) {
          Navigator.pop(context);
          Dialogs.showDialogWithMessage(
            context: context,
            title: 'Wystąpił bład',
            message: httpStatus.message,
          );
        }
      },
      child: child,
    );
  }
}

class _LostFocusAreaWithPaddings extends StatelessWidget {
  final Widget child;

  const _LostFocusAreaWithPaddings({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: GestureDetector(
        child: Container(
          height: double.infinity,
          color: Colors.transparent,
          child: child,
        ),
        onTap: () {
          Utils.unfocusElements();
        },
      ),
    );
  }
}
