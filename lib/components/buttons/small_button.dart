import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? color;

  const SmallButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color? backgroundColor = color;
    return SizedBox(
      height: 51.0,
      width: 150.0,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            backgroundColor ?? Theme.of(context).colorScheme.primary,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
        ),
      ),
    );
  }
}
