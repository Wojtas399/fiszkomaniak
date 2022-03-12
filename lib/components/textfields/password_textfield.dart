import 'package:fiszkomaniak/components/textfields/textfield_background.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../config/theme/text_field_theme.dart';

class PasswordTextField extends StatefulWidget {
  final String label;
  final Function(String value) onChanged;
  final String? Function(String? value)? validator;

  const PasswordTextField({
    Key? key,
    required this.label,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const TextFieldBackground(),
        TextFormField(
          cursorColor: Colors.black,
          obscureText: !_isPasswordVisible,
          onChanged: widget.onChanged,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: TextFieldTheme.basic(
            context: context,
            label: widget.label,
            icon: MdiIcons.lock,
            isPassword: true,
            isVisiblePassword: _isPasswordVisible,
            onPressedPasswordIcon: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        )
      ],
    );
  }
}