import 'package:flutter/material.dart';
import '../../config/theme/text_field_theme.dart';
import 'textfield_background.dart';

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isRequired;
  final Function(String value)? onChanged;
  final String? placeholder;
  final String? Function(String? value)? validator;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.icon,
    required this.label,
    this.isRequired = false,
    this.onChanged,
    this.placeholder,
    this.validator,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const TextFieldBackground(),
        TextFormField(
          onChanged: onChanged,
          validator: _validate,
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

  String? _validate(String? value) {
    if (isRequired && value == '') {
      return 'To pole jest wymagane!';
    }
    final String? Function(String? value)? customValidator = validator;
    if (customValidator != null) {
      return customValidator(value);
    }
    return null;
  }
}
