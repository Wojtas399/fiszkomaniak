import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_bloc.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/buttons/button.dart';
import 'group_preview_flashcards_state.dart';
import 'group_preview_information.dart';

class GroupPreviewContent extends StatelessWidget {
  const GroupPreviewContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupPreviewBloc, GroupPreviewState>(
      builder: (_, GroupPreviewState state) {
        final Group? group = state.group;
        if (group == null) {
          return const Center(
            child: Text('The group does not exist already'),
          );
        }
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
                const GroupPreviewInformation(),
                const GroupPreviewFlashcardsState(),
              ],
            ),
            Button(
              label: 'szybka sesja',
              onPressed: state.amountOfAllFlashcards == 0
                  ? null
                  : () => _quickSession(context),
            ),
          ],
        );
      },
    );
  }

  void _quickSession(BuildContext context) {
    context.read<GroupPreviewBloc>().add(GroupPreviewEventCreateQuickSession());
  }
}
