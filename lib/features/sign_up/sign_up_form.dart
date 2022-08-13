import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/navigation.dart';
import '../../providers/dialogs_provider.dart';
import '../../domain/use_cases/auth/sign_up_use_case.dart';
import '../../interfaces/achievements_interface.dart';
import '../../interfaces/auth_interface.dart';
import '../../interfaces/settings_interface.dart';
import '../../interfaces/user_interface.dart';
import '../../models/bloc_status.dart';
import '../../validators/email_validator.dart';
import '../../validators/password_validator.dart';
import '../../validators/username_validator.dart';
import 'bloc/sign_up_bloc.dart';
import 'components/sign_up_inputs.dart';
import 'components/sign_up_alternative_option.dart';
import 'components/sign_up_submit_button.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return _SignUpBlocProvider(
      child: _SignUpBlocListener(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _Header(),
            SizedBox(height: 24),
            SignUpInputs(),
            SizedBox(height: 16),
            SignUpSubmitButton(),
            SizedBox(height: 16),
            SignUpAlternativeOption(),
          ],
        ),
      ),
    );
  }
}

class _SignUpBlocProvider extends StatelessWidget {
  final Widget child;

  const _SignUpBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SignUpBloc(
        signUpUseCase: SignUpUseCase(
          authInterface: context.read<AuthInterface>(),
          userInterface: context.read<UserInterface>(),
          achievementsInterface: context.read<AchievementsInterface>(),
          settingsInterface: context.read<SettingsInterface>(),
        ),
        usernameValidator: UsernameValidator(),
        emailValidator: EmailValidator(),
        passwordValidator: PasswordValidator(),
      ),
      child: child,
    );
  }
}

class _SignUpBlocListener extends StatelessWidget {
  final Widget child;

  const _SignUpBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (BuildContext context, SignUpState state) {
        final BlocStatus blocStatus = state.status;
        if (blocStatus is BlocStatusLoading) {
          DialogsProvider.showLoadingDialog(context: context);
        } else if (blocStatus is BlocStatusComplete) {
          DialogsProvider.closeLoadingDialog(context);
          final SignUpInfo? info = blocStatus.info;
          if (info != null) {
            _manageInfo(info, context);
          }
        } else if (blocStatus is BlocStatusError) {
          DialogsProvider.closeLoadingDialog(context);
          final SignUpError? error = blocStatus.error;
          if (error != null) {
            _manageError(error, context);
          }
        }
      },
      child: child,
    );
  }

  void _manageInfo(SignUpInfo info, BuildContext context) {
    switch (info) {
      case SignUpInfo.userHasBeenSignedUp:
        Navigation.pushReplacementToHome(context);
        break;
    }
  }

  void _manageError(SignUpError error, BuildContext context) {
    switch (error) {
      case SignUpError.emailAlreadyInUse:
        DialogsProvider.showDialogWithMessage(
          context: context,
          title: 'Zajęty email',
          message:
              'Podany adres email jest już zajęty przez innego użytkownika',
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
      'Zarejestruj się',
      style: TextStyle(
        color: Colors.black,
        fontSize: 34,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
