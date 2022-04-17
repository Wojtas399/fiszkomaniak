import 'package:fiszkomaniak/components/app_bar_with_search_text_field.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_bloc.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_event.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupFlashcardsPreviewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const GroupFlashcardsPreviewAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupFlashcardsPreviewBloc, GroupFlashcardsPreviewState>(
      builder: (BuildContext context, GroupFlashcardsPreviewState state) {
        return AppBarWithSearchTextField(
          label: state.groupName ?? '',
          onChanged: (String value) {
            context.read<GroupFlashcardsPreviewBloc>().add(
                  GroupFlashcardsPreviewEventSearchValueChanged(
                    searchValue: value,
                  ),
                );
          },
        );
      },
    );
  }
}
