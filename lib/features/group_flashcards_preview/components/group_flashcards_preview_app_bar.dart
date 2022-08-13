import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/app_bar_with_search_text_field.dart';
import '../bloc/group_flashcards_preview_bloc.dart';

class GroupFlashcardsPreviewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const GroupFlashcardsPreviewAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final String groupName = context.select(
      (GroupFlashcardsPreviewBloc bloc) => bloc.state.groupName,
    );
    return AppBarWithSearchTextField(
      label: groupName,
      onChanged: (String value) => _onChangedSearchValue(value, context),
    );
  }

  void _onChangedSearchValue(String value, BuildContext context) {
    context.read<GroupFlashcardsPreviewBloc>().add(
          GroupFlashcardsPreviewEventSearchValueChanged(searchValue: value),
        );
  }
}
