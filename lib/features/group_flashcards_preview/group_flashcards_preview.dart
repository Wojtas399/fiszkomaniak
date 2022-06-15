import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_bloc.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_event.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/components/group_flashcards_preview_app_bar.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/components/group_flashcards_preview_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupFlashcardsPreview extends StatelessWidget {
  final String groupId;

  const GroupFlashcardsPreview({
    Key? key,
    required this.groupId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _GroupFlashcardsPreviewBlocProvider(
      groupId: groupId,
      child: const Scaffold(
        appBar: GroupFlashcardsPreviewAppBar(),
        body: GroupFlashcardsPreviewList(),
      ),
    );
  }
}

class _GroupFlashcardsPreviewBlocProvider extends StatelessWidget {
  final String groupId;
  final Widget child;

  const _GroupFlashcardsPreviewBlocProvider({
    Key? key,
    required this.groupId,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GroupFlashcardsPreviewBloc(
        navigation: context.read<Navigation>(),
      )..add(GroupFlashcardsPreviewEventInitialize(groupId: groupId)),
      child: child,
    );
  }
}
