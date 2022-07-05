import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_bloc.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/components/group_flashcards_preview_content.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupFlashcardsPreviewScreen extends StatelessWidget {
  final String groupId;

  const GroupFlashcardsPreviewScreen({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return _GroupFlashcardsPreviewBlocProvider(
      groupId: groupId,
      child: const GroupFlashcardsPreviewContent(),
    );
  }
}

class _GroupFlashcardsPreviewBlocProvider extends StatelessWidget {
  final String groupId;
  final Widget child;

  const _GroupFlashcardsPreviewBlocProvider({
    required this.groupId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GroupFlashcardsPreviewBloc(
        getGroupUseCase: GetGroupUseCase(
          groupsInterface: context.read<GroupsInterface>(),
        ),
      )..add(GroupFlashcardsPreviewEventInitialize(groupId: groupId)),
      child: child,
    );
  }
}
