import 'package:fiszkomaniak/components/group_item/group_item.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/features/course_groups_preview/bloc/course_groups_preview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/bouncing_scroll.dart';
import '../../../components/on_tap_focus_lose_area.dart';

class CourseGroupsPreviewList extends StatelessWidget {
  const CourseGroupsPreviewList({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnTapFocusLoseArea(
      child: BouncingScroll(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: _GroupsList(),
          ),
        ),
      ),
    );
  }
}

class _GroupsList extends StatelessWidget {
  const _GroupsList();

  @override
  Widget build(BuildContext context) {
    final List<GroupItemParams> groupsItemsParams = context.select(
      (CourseGroupsPreviewBloc bloc) => bloc.state.groupsItemsParams,
    );
    return Column(
      children: groupsItemsParams
          .map((group) => _createGroupItem(context, group))
          .toList(),
    );
  }

  Widget _createGroupItem(BuildContext context, GroupItemParams params) {
    return GroupItem(
      key: ValueKey(params.name),
      params: params,
      onPressed: () {
        context.read<Navigation>().navigateToGroupPreview(params.id);
      },
    );
  }
}
