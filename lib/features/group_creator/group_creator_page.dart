import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:fiszkomaniak/components/on_tap_focus_lose_area.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_bloc.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_event.dart';
import 'package:fiszkomaniak/features/group_creator/components/group_creator_course_selection.dart';
import 'package:fiszkomaniak/features/group_creator/components/group_creator_group_info.dart';
import 'package:fiszkomaniak/features/group_creator/components/group_creator_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupCreator extends StatelessWidget {
  const GroupCreator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _GroupCreatorBlocProvider(
      child: Scaffold(
        appBar: const AppBarWithCloseButton(label: 'Nowa grupa'),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: OnTapFocusLoseArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: const [
                      GroupCreatorCourseSelection(),
                      SizedBox(height: 24),
                      GroupCreatorGroupInfo(),
                    ],
                  ),
                  const GroupCreatorSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GroupCreatorBlocProvider extends StatelessWidget {
  final Widget child;

  const _GroupCreatorBlocProvider({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GroupCreatorBloc(
        coursesBloc: context.read<CoursesBloc>(),
        groupsBloc: context.read<GroupsBloc>(),
      )..add(GroupCreatorEventInitialize()),
      child: child,
    );
  }
}
