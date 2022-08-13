import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? color;

  const SmallButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final Color? backgroundColor = color;
    return SizedBox(
      height: 51.0,
      width: 150.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            backgroundColor ?? Theme.of(context).colorScheme.primary,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
