import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/session_preview/bloc/session_preview_mode.dart';
import '../../../components/buttons/button.dart';
import '../../../config/navigation.dart';
import '../bloc/group_preview_bloc.dart';
import 'group_preview_app_bar.dart';
import 'group_preview_flashcards_status.dart';
import 'group_preview_data.dart';

class GroupPreviewContent extends StatelessWidget {
  const GroupPreviewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: GroupPreviewAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: _Body(),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final bool doesGroupExist = context.select(
      (GroupPreviewBloc bloc) => bloc.state.doesGroupExist,
    );
    if (doesGroupExist) {
      return const _GroupInformation();
    }
    return const _NoGroupInfo();
  }
}

class _GroupInformation extends StatelessWidget {
  const _GroupInformation();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _GroupName(),
            SizedBox(height: 16),
            GroupPreviewData(),
            GroupPreviewFlashcardsStatus(),
          ],
        ),
        const _QuickSessionButton(),
      ],
    );
  }
}

class _GroupName extends StatelessWidget {
  const _GroupName();

  @override
  Widget build(BuildContext context) {
    final String? groupName = context.select(
      (GroupPreviewBloc bloc) => bloc.state.group?.name,
    );
    return Text(
      groupName ?? '',
      style: Theme.of(context).textTheme.headline5,
    );
  }
}

class _QuickSessionButton extends StatelessWidget {
  const _QuickSessionButton();

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (GroupPreviewBloc bloc) => bloc.state.isQuickSessionButtonDisabled,
    );
    return Button(
      label: 'szybka sesja',
      onPressed: isDisabled ? null : () => _onPressedQuickSession(context),
    );
  }

  void _onPressedQuickSession(BuildContext context) {
    final String? groupId = context.read<GroupPreviewBloc>().state.group?.id;
    if (groupId != null) {
      Navigation.navigateToSessionPreview(
        SessionPreviewModeQuick(groupId: groupId),
      );
    }
  }
}

class _NoGroupInfo extends StatelessWidget {
  const _NoGroupInfo();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('The group does not exist already'),
    );
  }
}
