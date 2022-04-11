import 'package:fiszkomaniak/components/flashcards_progress_bar.dart';
import 'package:fiszkomaniak/components/item_with_icon.dart';
import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_bloc.dart';
import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GroupSelectionFlashcardsInfo extends StatelessWidget {
  const GroupSelectionFlashcardsInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupSelectionBloc, GroupSelectionState>(
      builder: (_, GroupSelectionState state) {
        return Column(
          children: [
            ItemWithIcon(
              icon: MdiIcons.fileOutline,
              label: 'Nazwa dla pytań',
              text: state.nameForQuestions ?? '--',
              paddingLeft: 8,
              paddingRight: 8,
            ),
            ItemWithIcon(
              icon: MdiIcons.fileReplaceOutline,
              label: 'Nazwa dla odpowiedzi',
              text: state.nameForAnswers ?? '--',
              paddingLeft: 8,
              paddingRight: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0),
              child: FlashcardsProgressBar(
                amountOfLearnedFlashcards:
                    state.amountOfRememberedFlashcardsFromGroup,
                amountOfAllFlashcards: state.amountOfAllFlashcardsFromGroup,
                barHeight: 16,
              ),
            ),
          ],
        );
      },
    );
  }
}
