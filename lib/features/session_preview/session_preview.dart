import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:flutter/material.dart';

class SessionPreview extends StatelessWidget {
  final String sessionId;

  const SessionPreview({
    Key? key,
    required this.sessionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWithCloseButton(label: 'Sesja'),
      body: Center(
        child: Text('Session preview'),
      ),
    );
  }
}
