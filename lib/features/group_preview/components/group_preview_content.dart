import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter/material.dart';
import '../../../components/button.dart';
import 'group_preview_flashcards_state.dart';
import 'group_preview_information.dart';

class GroupPreviewContent extends StatelessWidget {
  final Group group;

  const GroupPreviewContent({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group.name,
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 16),
            GroupPreviewInformation(
              courseId: group.courseId,
              nameForQuestions: group.nameForQuestions,
              nameForAnswers: group.nameForAnswers,
            ),
            GroupPreviewFlashcardsState(groupId: group.id),
          ],
        ),
        Button(
          label: 'przeglądaj fiszki',
          onPressed: () {},
        ),
      ],
    );
  }
}
