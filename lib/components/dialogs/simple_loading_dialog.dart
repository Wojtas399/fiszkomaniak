import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';

class SimpleLoadingDialog extends StatelessWidget {
  final String? text;

  const SimpleLoadingDialog({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      contentPadding: const EdgeInsets.all(16.0),
      children: [
        Center(
          child: Column(
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 16),
              Text(text ?? 'Proszę czekaj...'),
            ],
          ),
        )
      ],
    );
  }
}
