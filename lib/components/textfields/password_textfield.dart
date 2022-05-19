import 'package:fiszkomaniak/components/textfields/textfield_background.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../config/theme/text_field_theme.dart';

class PasswordTextField extends StatefulWidget {
  final String label;
  final bool isRequired;
  final Function(String value)? onChanged;
  final String? Function(String? value)? validator;
  final TextEditingController? controller;

  const PasswordTextField({
    super.key,
    required this.label,
    this.isRequired = false,
    this.onChanged,
    this.validator,
    this.controller,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const TextFieldBackground(),
        TextFormField(
          obscureText: !_isPasswordVisible,
          onChanged: widget.onChanged,
          validator: _validate,
          controller: widget.controller,
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

  String? _validate(String? value) {
    if (widget.isRequired && value == '') {
      return 'To pole jest wymagane!';
    }
    final String? Function(String? value)? validator = widget.validator;
    if (validator != null) {
      return validator(value);
    }
    return null;
  }
}
