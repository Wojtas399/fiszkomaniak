import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String text;
  final String? confirmButtonText;
  final String? cancelButtonText;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.text,
    this.confirmButtonText,
    this.cancelButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(text),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text(cancelButtonText ?? 'Anuluj'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(confirmButtonText ?? 'Potwierdź'),
        ),
      ],
    );
  }
}
