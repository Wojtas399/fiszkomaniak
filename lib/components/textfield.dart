import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? placeholder;
  final ValueNotifier<bool> _isPassword = ValueNotifier(false);
  final ValueNotifier<bool> _isVisiblePassword = ValueNotifier(false);

  CustomTextField({
    Key? key,
    required this.icon,
    required this.label,
    this.placeholder,
    bool? isPassword,
  }) : super(key: key) {
    if (isPassword != null) {
      _isPassword.value = isPassword;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _Background(
      child: ValueListenableBuilder(
        valueListenable: _isPassword,
        builder: (_, bool isPassword, Widget? child) {
          return ValueListenableBuilder(
            valueListenable: _isVisiblePassword,
            builder: (_, bool isVisiblePassword, Widget? child) {
              return TextField(
                cursorColor: Colors.black,
                obscureText: isPassword && !isVisiblePassword,
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  hintText: placeholder,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 8,
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 2.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  errorMaxLines: 2,
                  prefixIconConstraints: const BoxConstraints(minWidth: 40),
                  prefixIcon: Icon(icon),
                  suffixIcon: isPassword
                      ? IconButton(
                          icon: Icon(
                            isVisiblePassword == false
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            _isVisiblePassword.value = !isVisiblePassword;
                          },
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _Background extends StatelessWidget {
  final Widget child;

  const _Background({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      child: child,
    );
  }
}
