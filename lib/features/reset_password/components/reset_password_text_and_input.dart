import 'package:fiszkomaniak/features/reset_password/bloc/reset_password_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/textfield.dart';
import '../bloc/reset_password_event.dart';
import '../bloc/reset_password_state.dart';

class ResetPasswordTextAndInput extends StatelessWidget {
  const ResetPasswordTextAndInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
      builder: (context, state) {
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
              label: 'Adres e-mail',
              onChanged: (String value) {
                context
                    .read<ResetPasswordBloc>()
                    .add(ResetPasswordEventEmailChanged(email: value));
              },
            ),
          ],
        );
      },
    );
  }
}
