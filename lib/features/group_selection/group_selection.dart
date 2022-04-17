import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_bloc.dart';
import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_event.dart';
import 'package:fiszkomaniak/features/group_selection/components/group_selection_button.dart';
import 'package:fiszkomaniak/features/group_selection/components/group_selection_flashcards_info.dart';
import 'package:fiszkomaniak/features/group_selection/components/group_selection_select_course_item.dart';
import 'package:fiszkomaniak/features/group_selection/components/group_selection_select_group_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/groups/groups_bloc.dart';

class GroupSelection extends StatelessWidget {
  final ScrollController scrollController = ScrollController();

  GroupSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _GroupSelectionBlocProvider(
      child: Scaffold(
        appBar: const AppBarWithCloseButton(label: 'Wybór grupy'),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              bottom: 24.0,
              left: 24.0,
              right: 24.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: const [
                    GroupSelectionSelectCourseItem(),
                    GroupSelectionSelectGroupItem(),
                    GroupSelectionFlashcardsInfo(),
                  ],
                ),
                const GroupSelectionButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GroupSelectionBlocProvider extends StatelessWidget {
  final Widget child;

  const _GroupSelectionBlocProvider({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GroupSelectionBloc(
        coursesBloc: context.read<CoursesBloc>(),
        groupsBloc: context.read<GroupsBloc>(),
        flashcardsBloc: context.read<FlashcardsBloc>(),
      )..add(GroupSelectionEventInitialize()),
      child: child,
    );
  }
}
