import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_bloc.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_dialogs.dart';
import 'package:fiszkomaniak/features/group_preview/components/group_preview_app_bar.dart';
import 'package:fiszkomaniak/features/group_preview/components/group_preview_content.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupPreview extends StatelessWidget {
  final String groupId;

  const GroupPreview({Key? key, required this.groupId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _GroupPreviewBlocProvider(
      groupId: groupId,
      child: const Scaffold(
        appBar: GroupPreviewAppBar(),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: GroupPreviewContent(),
          ),
        ),
      ),
    );
  }
}

class _GroupPreviewBlocProvider extends StatelessWidget {
  final String groupId;
  final Widget child;

  const _GroupPreviewBlocProvider({
    Key? key,
    required this.groupId,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GroupPreviewBloc(
        groupsBloc: context.read<GroupsBloc>(),
        coursesInterface: context.read<CoursesInterface>(),
        groupPreviewDialogs: GroupPreviewDialogs(),
        navigation: context.read<Navigation>(),
      )..add(GroupPreviewEventInitialize(groupId: groupId)),
      child: child,
    );
  }
}
