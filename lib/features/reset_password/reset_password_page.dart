import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:fiszkomaniak/components/on_tap_focus_lose_area.dart';
import 'package:fiszkomaniak/features/reset_password/reset_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../components/buttons/button.dart';
import '../../components/textfields/custom_textfield.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        label: 'Zmiana hasła',
        leadingIcon: MdiIcons.close,
      ),
      body: SafeArea(
        child: OnTapFocusLoseArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _ResetPasswordCubitProvider(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _ResetPasswordTextAndInput(),
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

class _ResetPasswordCubitProvider extends StatelessWidget {
  final Widget child;

  const _ResetPasswordCubitProvider({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ResetPasswordCubit(
          // authBloc: context.read<AuthBloc>(),
          ),
      child: child,
    );
  }
}

class _ResetPasswordTextAndInput extends StatelessWidget {
  const _ResetPasswordTextAndInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Zapomniałeś hasła?',
          style: Theme.of(context).textTheme.headline5,
        ),
        const SizedBox(height: 8),
        Text(
          'Podaj adres e-mail na który otrzymasz wiadomość z instrukcjami dotyczącymi resetowania hasła.',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          icon: MdiIcons.email,
          isRequired: true,
          label: 'Adres e-mail',
          onChanged: (String value) {
            context.read<ResetPasswordCubit>().emailChanged(value);
          },
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (ResetPasswordCubit cubit) => cubit.isButtonDisabled,
    );
    return Button(
      label: 'Wyślij',
      onPressed: isDisabled ? null : () => _submit(context),
    );
  }

  void _submit(BuildContext context) {
    context.read<ResetPasswordCubit>().submit();
  }
}
