import 'package:fiszkomaniak/components/group_item/group_item.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/features/study/bloc/study_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudyGroupsList extends StatelessWidget {
  const StudyGroupsList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GroupItemParams> groupsParams = context.select(
      (StudyBloc bloc) => bloc.state.groupsItemsParams,
    );
    return Column(
      children: groupsParams
          .map((params) => _buildGroupItem(context, params))
          .toList(),
    );
  }

  Widget _buildGroupItem(BuildContext context, GroupItemParams params) {
    return GroupItem(
      params: params,
      onPressed: () {
        context.read<Navigation>().navigateToGroupPreview(params.id);
      },
    );
  }
}
