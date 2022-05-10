import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final Function()? onPressed;

  const Button({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color disabledColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return SizedBox(
      width: 320,
      height: 51,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(onSurface: disabledColor),
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
