import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:fiszkomaniak/components/bouncing_scroll.dart';
import 'package:fiszkomaniak/features/session_creator/components/session_creator_date_and_time.dart';
import 'package:fiszkomaniak/features/session_creator/components/session_creator_flashcards.dart';
import 'package:flutter/material.dart';

class SessionCreator extends StatelessWidget {
  const SessionCreator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithCloseButton(label: 'Nowa sesja'),
      body: BouncingScroll(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: const [
                SessionCreatorFlashcards(),
                SessionCreatorDateAndTime(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
