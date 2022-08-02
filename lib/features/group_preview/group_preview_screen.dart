import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/remove_group_use_case.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_bloc.dart';
import 'package:fiszkomaniak/features/group_preview/group_preview_dialogs.dart';
import 'package:fiszkomaniak/features/group_preview/components/group_preview_app_bar.dart';
import 'package:fiszkomaniak/features/group_preview/components/group_preview_content.dart';
import 'package:fiszkomaniak/features/home/home.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/navigation.dart';

class GroupPreviewScreen extends StatelessWidget {
  final String groupId;

  const GroupPreviewScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return _GroupPreviewBlocProvider(
      groupId: groupId,
      child: const _GroupPreviewBlocListener(
        child: Scaffold(
          appBar: GroupPreviewAppBar(),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: GroupPreviewContent(),
            ),
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
    required this.groupId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final GroupsInterface groupsInterface = context.read<GroupsInterface>();
    return BlocProvider(
      create: (BuildContext context) => GroupPreviewBloc(
        getGroupUseCase: GetGroupUseCase(groupsInterface: groupsInterface),
        removeGroupUseCase:
            RemoveGroupUseCase(groupsInterface: groupsInterface),
        getCourseUseCase: GetCourseUseCase(
          coursesInterface: context.read<CoursesInterface>(),
        ),
        groupPreviewDialogs: GroupPreviewDialogs(),
      )..add(GroupPreviewEventInitialize(groupId: groupId)),
      child: child,
    );
  }
}

class _GroupPreviewBlocListener extends StatelessWidget {
  final Widget child;

  const _GroupPreviewBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupPreviewBloc, GroupPreviewState>(
      listener: (BuildContext context, GroupPreviewState state) {
        final BlocStatus blocStatus = state.status;
        if (blocStatus is BlocStatusLoading) {
          Dialogs.showLoadingDialog();
        } else if (blocStatus is BlocStatusComplete) {
          Dialogs.closeLoadingDialog(context);
          final GroupPreviewInfoType? info = blocStatus.info;
          if (info != null) {
            _manageBlocInfo(info, context);
          }
        }
      },
      child: child,
    );
  }

  void _manageBlocInfo(GroupPreviewInfoType info, BuildContext context) {
    switch (info) {
      case GroupPreviewInfoType.groupHasBeenRemoved:
        context.read<Navigation>().backHome();
        context.read<HomePageController>().moveToPage(0);
        Dialogs.showSnackbarWithMessage('Pomyślnie usunięto grupę.');
        break;
    }
  }
}
