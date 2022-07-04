import 'package:flutter/material.dart';
import '../../../components/bouncing_scroll.dart';
import '../../../components/on_tap_focus_lose_area.dart';
import 'flashcards_editor_app_bar.dart';
import 'flashcards_editor_list.dart';

class FlashcardsEditorContent extends StatelessWidget {
  const FlashcardsEditorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: FlashcardsEditorAppBar(),
      body: BouncingScroll(
        child: OnTapFocusLoseArea(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: FlashcardsEditorList(),
            ),
          ),
        ),
      ),
    );
  }
}
