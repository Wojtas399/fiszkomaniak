import 'package:fiszkomaniak/components/textfields/textfield_background.dart';
import 'package:fiszkomaniak/config/theme/text_field_theme.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function(String value) onChanged;
  final String? placeholder;
  final String? Function(String? value)? validator;

  const CustomTextField({
    Key? key,
    required this.icon,
    required this.label,
    required this.onChanged,
    this.placeholder,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const TextFieldBackground(),
        TextFormField(
          cursorColor: Colors.black,
          onChanged: onChanged,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: TextFieldTheme.basic(
            context: context,
            label: label,
            icon: icon,
          ),
        ),
      ],
    );
  }
}
