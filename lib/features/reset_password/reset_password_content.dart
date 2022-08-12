import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../components/app_bar_with_close_button.dart';
import '../../components/buttons/button.dart';
import '../../components/on_tap_focus_lose_area.dart';
import '../../components/textfields/custom_textfield.dart';
import 'bloc/reset_password_bloc.dart';

class ResetPasswordContent extends StatelessWidget {
  const ResetPasswordContent({super.key});

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _DescriptionAndInput(),
                _SubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DescriptionAndInput extends StatelessWidget {
  const _DescriptionAndInput();

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
          'Podaj adres e-mail na który otrzymasz wiadomość z instrukcją dotyczącą resetowania hasła.',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          icon: MdiIcons.email,
          isRequired: true,
          label: 'Adres e-mail',
          onChanged: (String email) => _onChangedEmail(email, context),
        ),
      ],
    );
  }

  void _onChangedEmail(String email, BuildContext context) {
    context
        .read<ResetPasswordBloc>()
        .add(ResetPasswordEventEmailChanged(email: email));
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (ResetPasswordBloc bloc) => bloc.state.isButtonDisabled,
    );
    return Button(
      label: 'Wyślij',
      onPressed: isDisabled ? null : () => _submit(context),
    );
  }

  void _submit(BuildContext context) {
    context.read<ResetPasswordBloc>().add(ResetPasswordEventSubmit());
  }
}
