import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final Function()? onPressed;

  const Button({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 51,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
