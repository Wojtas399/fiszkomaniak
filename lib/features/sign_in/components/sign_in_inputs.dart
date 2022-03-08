import 'package:fiszkomaniak/components/textfield.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignInInputs extends StatelessWidget {
  const SignInInputs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          label: 'Adres e-mail',
          icon: MdiIcons.email,
          onChanged: (String value) {},
        ),
        const SizedBox(height: 8),
        CustomTextField(
          label: 'Hasło',
          icon: MdiIcons.lock,
          isPassword: true,
          onChanged: (String value) {},
        ),
      ],
    );
  }
}
