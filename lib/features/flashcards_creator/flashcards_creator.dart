import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:flutter/material.dart';

class FlashcardsCreator extends StatelessWidget {
  const FlashcardsCreator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWithCloseButton(label: 'Nowe fiszki'),
      body: Center(
        child: Text('Flashcards creator page'),
      ),
    );
  }
}
