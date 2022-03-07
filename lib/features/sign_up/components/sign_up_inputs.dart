import 'package:fiszkomaniak/components/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignUpInputs extends StatelessWidget {
  const SignUpInputs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          icon: MdiIcons.account,
          label: 'Nazwa użytkownika',
          placeholder: 'np. Jan Nowak',
        ),
        const _FreeSpace(),
        CustomTextField(
          icon: MdiIcons.email,
          label: 'Adres e-mail',
          placeholder: 'np. jan.nowak@example.com',
        ),
        const _FreeSpace(),
        CustomTextField(
          icon: MdiIcons.lock,
          label: 'Hasło',
          isPassword: true,
        ),
        const _FreeSpace(),
        CustomTextField(
          icon: MdiIcons.lock,
          label: 'Powtórz hasło',
          isPassword: true,
        ),
      ],
    );
  }
}

class _FreeSpace extends StatelessWidget {
  const _FreeSpace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 24);
  }
}
