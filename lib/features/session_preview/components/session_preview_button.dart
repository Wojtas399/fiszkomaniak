import 'package:fiszkomaniak/components/button.dart';
import 'package:flutter/material.dart';

class SessionPreviewButton extends StatelessWidget {
  const SessionPreviewButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24.0,
      left: 24.0,
      right: 24.0,
      child: Button(
        label: 'rozpocznij naukę',
        onPressed: () {},
      ),
    );
  }
}
