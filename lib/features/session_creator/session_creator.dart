import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:flutter/material.dart';

class SessionCreator extends StatelessWidget {
  const SessionCreator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWithCloseButton(label: 'Nowa sesja'),
      body: Center(
        child: Text('Session creator page'),
      ),
    );
  }
}
