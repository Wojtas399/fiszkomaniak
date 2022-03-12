import 'package:fiszkomaniak/config/theme/text_field_theme.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function(String value) onChanged;
  final String? placeholder;
  final String? Function(String? value)? validator;
  final ValueNotifier<bool> _isPassword = ValueNotifier(false);
  final ValueNotifier<bool> _isVisiblePassword = ValueNotifier(false);

  CustomTextField({
    Key? key,
    required this.icon,
    required this.label,
    required this.onChanged,
    this.placeholder,
    this.validator,
    bool? isPassword,
  }) : super(key: key) {
    if (isPassword != null) {
      _isPassword.value = isPassword;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const _Background(),
        ValueListenableBuilder(
          valueListenable: _isPassword,
          builder: (_, bool isPassword, Widget? child) {
            return ValueListenableBuilder(
              valueListenable: _isVisiblePassword,
              builder: (_, bool isVisiblePassword, Widget? child) {
                return TextFormField(
                  cursorColor: Colors.black,
                  obscureText: isPassword && !isVisiblePassword,
                  onChanged: onChanged,
                  validator: validator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: TextFieldTheme.basic(
                    context: context,
                    label: label,
                    icon: icon,
                    isPassword: isPassword,
                    isVisiblePassword: isVisiblePassword,
                    onPressedPasswordIcon: () {
                      _isVisiblePassword.value = !isVisiblePassword;
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _Background extends StatelessWidget {
  const _Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
    );
  }
}
