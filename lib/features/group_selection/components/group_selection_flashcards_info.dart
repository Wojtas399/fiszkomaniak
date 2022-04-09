import 'package:fiszkomaniak/components/flashcards_progress_bar.dart';
import 'package:fiszkomaniak/components/item_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GroupSelectionFlashcardsInfo extends StatelessWidget {
  const GroupSelectionFlashcardsInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        ItemWithIcon(
          icon: MdiIcons.fileOutline,
          label: 'Nazwa dla pytań',
          text: '--',
          paddingLeft: 8,
          paddingRight: 8,
        ),
        ItemWithIcon(
          icon: MdiIcons.fileReplaceOutline,
          label: 'Nazwa dla odpowiedzi',
          text: '--',
          paddingLeft: 8,
          paddingRight: 8,
        ),
        Padding(
          padding: EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0),
          child: FlashcardsProgressBar(
            amountOfLearnedFlashcards: 0,
            amountOfAllFlashcards: 0,
            barHeight: 16,
          ),
        ),
      ],
    );
  }
}
