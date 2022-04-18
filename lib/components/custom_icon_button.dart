import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Material(
        color: Colors.transparent,
        child: IconButton(
          padding: const EdgeInsets.all(16.0),
          onPressed: onPressed,
          icon: Icon(icon),
        ),
      ),
    );
  }
}
