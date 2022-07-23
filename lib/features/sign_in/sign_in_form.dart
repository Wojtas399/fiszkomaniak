import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/auth/sign_in_use_case.dart';
import '../../../interfaces/auth_interface.dart';
import '../../../components/dialogs/dialogs.dart';
import '../../../models/bloc_status.dart';
import 'bloc/sign_in_bloc.dart';
import 'components/sign_in_submit_button.dart';
import 'components/sign_in_alternative_options.dart';
import 'components/sign_in_inputs.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return _SignInBlocProvider(
      child: _SignInBlocListener(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _Header(),
            SizedBox(height: 24),
            SignInInputs(),
            SizedBox(height: 8),
            SignInSubmitButton(),
            SizedBox(height: 16),
            AlternativeOptions(),
          ],
        ),
      ),
    );
  }
}

class _SignInBlocProvider extends StatelessWidget {
  final Widget child;

  const _SignInBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SignInBloc(
        signInUseCase: SignInUseCase(
          authInterface: context.read<AuthInterface>(),
        ),
      ),
      child: child,
    );
  }
}

class _SignInBlocListener extends StatelessWidget {
  final Widget child;

  const _SignInBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (BuildContext context, SignInState state) {
        final BlocStatus blocStatus = state.status;
        if (blocStatus is BlocStatusLoading) {
          Dialogs.showLoadingDialog(context: context);
        } else if (blocStatus is BlocStatusComplete) {
          Dialogs.closeLoadingDialog(context);
          final SignInInfoType? infoType = blocStatus.info;
          if (infoType != null) {
            _manageInfoType(infoType, context);
          }
        }
      },
      child: child,
    );
  }

  void _manageInfoType(SignInInfoType infoType, BuildContext context) {
    switch (infoType) {
      case SignInInfoType.userNotFound:
        Dialogs.showDialogWithMessage(
          context: context,
          title: 'Brak użytkownika',
          message:
              'Nie znaleziono zarejestrowanego użytkownika o podanym adresie email',
        );
        break;
      case SignInInfoType.invalidEmail:
        Dialogs.showDialogWithMessage(
          title: 'Nieprawidłowy adres email',
          message: 'Podano nieprawidłowy adres email',
        );
        break;
      case SignInInfoType.wrongPassword:
        Dialogs.showDialogWithMessage(
          context: context,
          title: 'Niepoprawne hasło',
          message: 'Podano niepoprawne hasło dla tego użytkownika',
        );
        break;
    }
  }
}

class _Header extends StatelessWidget {
  const _Header();

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
