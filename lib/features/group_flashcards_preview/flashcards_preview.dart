import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_bloc.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_event.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/components/group_flashcards_preview_app_bar.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/components/group_flashcards_preview_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/flashcards/flashcards_bloc.dart';

class GroupFlashcardsPreview extends StatelessWidget {
  final String groupId;

  const GroupFlashcardsPreview({
    Key? key,
    required this.groupId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlashcardsPreviewBlocProvider(
      groupId: groupId,
      child: const Scaffold(
        appBar: GroupFlashcardsPreviewAppBar(),
        body: GroupFlashcardsPreviewList(),
      ),
    );
  }
}

class FlashcardsPreviewBlocProvider extends StatelessWidget {
  final String groupId;
  final Widget child;

  const FlashcardsPreviewBlocProvider({
    Key? key,
    required this.groupId,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GroupFlashcardsPreviewBloc(
        groupsBloc: context.read<GroupsBloc>(),
        flashcardsBloc: context.read<FlashcardsBloc>(),
      )..add(GroupFlashcardsPreviewEventInitialize(groupId: groupId)),
      child: child,
    );
  }
}
