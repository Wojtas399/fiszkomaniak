import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/dialogs/dialogs.dart';
import '../../config/navigation.dart';
import '../../domain/use_cases/courses/get_course_use_case.dart';
import '../../domain/use_cases/groups/get_group_use_case.dart';
import '../../domain/use_cases/groups/delete_group_use_case.dart';
import '../../features/home/home.dart';
import '../../interfaces/courses_interface.dart';
import '../../interfaces/groups_interface.dart';
import '../../models/bloc_status.dart';
import 'bloc/group_preview_bloc.dart';
import 'components/group_preview_content.dart';

class GroupPreviewScreen extends StatelessWidget {
  final String groupId;

  const GroupPreviewScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return _GroupPreviewBlocProvider(
      groupId: groupId,
      child: const _GroupPreviewBlocListener(
        child: GroupPreviewContent(),
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
    return BlocProvider(
      create: (BuildContext context) => GroupPreviewBloc(
        getGroupUseCase: GetGroupUseCase(
          groupsInterface: context.read<GroupsInterface>(),
        ),
        deleteGroupUseCase: DeleteGroupUseCase(
          groupsInterface: context.read<GroupsInterface>(),
        ),
        getCourseUseCase: GetCourseUseCase(
          coursesInterface: context.read<CoursesInterface>(),
        ),
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
          final GroupPreviewInfo? info = blocStatus.info;
          if (info != null) {
            _manageInfo(info, context);
          }
        }
      },
      child: child,
    );
  }

  void _manageInfo(GroupPreviewInfo info, BuildContext context) {
    switch (info) {
      case GroupPreviewInfo.groupHasBeenDeleted:
        Navigation.backHome();
        context.read<HomePageController>().moveToPage(0);
        Dialogs.showSnackbarWithMessage('Pomyślnie usunięto grupę.');
        break;
    }
  }
}
