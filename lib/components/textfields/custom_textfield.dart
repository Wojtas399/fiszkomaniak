import 'package:fiszkomaniak/components/textfields/textfield_background.dart';
import 'package:fiszkomaniak/config/theme/text_field_theme.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function(String value)? onChanged;
  final String? placeholder;
  final String? Function(String? value)? validator;
  final TextEditingController? controller;

  const CustomTextField({
    Key? key,
    required this.icon,
    required this.label,
    this.onChanged,
    this.placeholder,
    this.validator,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const TextFieldBackground(),
        TextFormField(
          onChanged: onChanged,
          validator: validator,
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: TextFieldTheme.basic(
            context: context,
            label: label,
            icon: icon,
            placeholder: placeholder,
          ),
        ),
      ],
    );
  }
}
