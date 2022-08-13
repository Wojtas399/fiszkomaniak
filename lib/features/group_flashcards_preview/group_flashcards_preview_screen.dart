import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/groups/get_group_use_case.dart';
import '../../interfaces/groups_interface.dart';
import 'bloc/group_flashcards_preview_bloc.dart';
import 'components/group_flashcards_preview_content.dart';

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
