import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:fiszkomaniak/components/buttons/button.dart';
import 'package:fiszkomaniak/components/on_tap_focus_lose_area.dart';
import 'package:fiszkomaniak/components/textfields/password_textfield.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/features/profile/components/password_editor/bloc/password_editor_bloc.dart';
import 'package:fiszkomaniak/validators/password_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PasswordEditor extends StatelessWidget {
  const PasswordEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        leadingIcon: MdiIcons.close,
        label: 'Zmiana hasła',
      ),
      body: SafeArea(
        child: OnTapFocusLoseArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _PasswordEditorBlocProvider(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _TextFields(),
                  _SubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordEditorBlocProvider extends StatelessWidget {
  final Widget child;

  const _PasswordEditorBlocProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PasswordEditorBloc(
        navigation: context.read<Navigation>(),
        passwordValidator: PasswordValidator(),
      ),
      child: child,
    );
  }
}

class _TextFields extends StatelessWidget {
  const _TextFields({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 8.0);
    return Column(
      children: const [
        gap,
        _CurrentPassword(),
        gap,
        _NewPassword(),
        gap,
        _NewPasswordConfirmation(),
      ],
    );
  }
}

class _CurrentPassword extends StatelessWidget {
  const _CurrentPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PasswordTextField(
      label: 'Obecne hasło',
      isRequired: true,
      validator: (String? value) {
        if (value == '') {
          return 'To pole jest wymagane';
        }
        return null;
      },
      onChanged: (String value) => _onChanged(context, value),
    );
  }

  void _onChanged(BuildContext context, String value) {
    context
        .read<PasswordEditorBloc>()
        .add(PasswordEditorEventCurrentPasswordChanged(value: value));
  }
}

class _NewPassword extends StatelessWidget {
  const _NewPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isCorrect = context.select(
      (PasswordEditorBloc bloc) => bloc.state.isNewPasswordCorrect,
    );
    return PasswordTextField(
      label: 'Nowe hasło',
      isRequired: true,
      validator: (String? value) {
        if (isCorrect) {
          return null;
        }
        return PasswordValidator.message;
      },
      onChanged: (String value) => _onChanged(context, value),
    );
  }

  void _onChanged(BuildContext context, String value) {
    context
        .read<PasswordEditorBloc>()
        .add(PasswordEditorEventNewPasswordChanged(value: value));
  }
}

class _NewPasswordConfirmation extends StatelessWidget {
  const _NewPasswordConfirmation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isCorrect = context.select(
      (PasswordEditorBloc bloc) => bloc.state.isNewPasswordConfirmationCorrect,
    );
    return PasswordTextField(
      label: 'Powtórz nowe hasło',
      isRequired: true,
      validator: (String? value) {
        if (isCorrect) {
          return null;
        }
        return 'Hasła nie są jednakowe';
      },
      onChanged: (String value) => _onChanged(context, value),
    );
  }

  void _onChanged(BuildContext context, String value) {
    context
        .read<PasswordEditorBloc>()
        .add(PasswordEditorEventNewPasswordConfirmationChanged(value: value));
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (PasswordEditorBloc bloc) => bloc.state.isButtonDisabled,
    );
    return Button(
      label: 'Zapisz',
      onPressed: isDisabled ? null : () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<PasswordEditorBloc>().add(PasswordEditorEventSubmit());
  }
}
