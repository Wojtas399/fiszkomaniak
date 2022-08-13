import 'package:flutter/material.dart';

class TextFieldBackground extends StatelessWidget {
  const TextFieldBackground({super.key});

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withOpacity(0.04)
        : Colors.black.withOpacity(0.04);
    return Container(
      height: 56,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
    );
  }
}
