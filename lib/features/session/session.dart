import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:flutter/material.dart';

class Session extends StatelessWidget {
  const Session({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(label: 'Sesja'),
      body: Center(
        child: Text('Session'),
      ),
    );
  }
}
