import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/dialogs/dialogs.dart';
import '../../../domain/use_cases/auth/sign_up_use_case.dart';
import '../../../interfaces/achievements_interface.dart';
import '../../../interfaces/auth_interface.dart';
import '../../../interfaces/user_interface.dart';
import '../../../interfaces/appearance_settings_interface.dart';
import '../../../interfaces/notifications_settings_interface.dart';
import '../../../models/bloc_status.dart';
import '../../../validators/email_validator.dart';
import '../../../validators/password_validator.dart';
import '../../../validators/username_validator.dart';
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
          appearanceSettingsInterface:
              context.read<AppearanceSettingsInterface>(),
          notificationsSettingsInterface:
              context.read<NotificationsSettingsInterface>(),
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
          Dialogs.showLoadingDialog(context: context);
        } else if (blocStatus is BlocStatusComplete) {
          Dialogs.closeLoadingDialog(context);
        } else if (blocStatus is BlocStatusError) {
          Dialogs.closeLoadingDialog(context);
          final SignUpErrorType? errorType = blocStatus.errorType;
          if (errorType != null) {
            _manageErrorType(errorType, context);
          }
        }
      },
      child: child,
    );
  }

  void _manageErrorType(SignUpErrorType errorType, BuildContext context) {
    switch (errorType) {
      case SignUpErrorType.emailAlreadyInUse:
        Dialogs.showDialogWithMessage(
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
