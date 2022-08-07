import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/dialogs/dialogs.dart';
import '../../config/navigation.dart';
import '../../domain/use_cases/courses/get_all_courses_use_case.dart';
import '../../domain/use_cases/courses/load_all_courses_use_case.dart';
import '../../domain/use_cases/groups/add_group_use_case.dart';
import '../../domain/use_cases/groups/check_group_name_usage_in_course_use_case.dart';
import '../../domain/use_cases/groups/update_group_use_case.dart';
import '../../features/home/home.dart';
import '../../interfaces/courses_interface.dart';
import '../../interfaces/groups_interface.dart';
import '../../models/bloc_status.dart';
import 'bloc/group_creator_bloc.dart';
import 'components/group_creator_content.dart';
import 'group_creator_mode.dart';

class GroupCreatorScreen extends StatelessWidget {
  final GroupCreatorMode mode;

  const GroupCreatorScreen({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return _GroupCreatorBlocProvider(
      mode: mode,
      child: const _GroupCreatorBlocListener(
        child: GroupCreatorContent(),
      ),
    );
  }
}

class _GroupCreatorBlocProvider extends StatelessWidget {
  final GroupCreatorMode mode;
  final Widget child;

  const _GroupCreatorBlocProvider({
    required this.child,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    final CoursesInterface coursesInterface = context.read<CoursesInterface>();
    final GroupsInterface groupsInterface = context.read<GroupsInterface>();
    return BlocProvider(
      create: (_) => GroupCreatorBloc(
        getAllCoursesUseCase: GetAllCoursesUseCase(
          coursesInterface: coursesInterface,
        ),
        loadAllCoursesUseCase: LoadAllCoursesUseCase(
          coursesInterface: coursesInterface,
        ),
        checkGroupNameUsageInCourseUseCase: CheckGroupNameUsageInCourseUseCase(
          groupsInterface: groupsInterface,
        ),
        addGroupUseCase: AddGroupUseCase(groupsInterface: groupsInterface),
        updateGroupUseCase: UpdateGroupUseCase(
          groupsInterface: groupsInterface,
        ),
      )..add(GroupCreatorEventInitialize(mode: mode)),
      child: child,
    );
  }
}

class _GroupCreatorBlocListener extends StatelessWidget {
  final Widget child;

  const _GroupCreatorBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupCreatorBloc, GroupCreatorState>(
      listener: (BuildContext context, GroupCreatorState state) {
        final BlocStatus blocStatus = state.status;
        if (blocStatus is BlocStatusLoading) {
          Dialogs.showLoadingDialog();
        } else if (blocStatus is BlocStatusComplete) {
          Dialogs.closeLoadingDialog(context);
          final GroupCreatorInfo? info = blocStatus.info;
          if (info != null) {
            _manageInfo(info, context);
          }
        } else if (blocStatus is BlocStatusError) {
          Dialogs.closeLoadingDialog(context);
          final GroupCreatorError? error = blocStatus.error;
          if (error != null) {
            _manageError(error);
          }
        }
      },
      child: child,
    );
  }

  void _manageInfo(GroupCreatorInfo info, BuildContext context) {
    switch (info) {
      case GroupCreatorInfo.groupHasBeenAdded:
        context.read<Navigation>().backHome();
        context.read<HomePageController>().moveToPage(0);
        Dialogs.showSnackbarWithMessage('Pomyślnie dodano nową grupę.');
        break;
      case GroupCreatorInfo.groupHasBeenEdited:
        context.read<Navigation>().moveBack();
        Dialogs.showSnackbarWithMessage('Pomyślnie zaktualizaowano grupę.');
        break;
    }
  }

  void _manageError(GroupCreatorError error) {
    switch (error) {
      case GroupCreatorError.groupNameIsAlreadyTaken:
        Dialogs.showDialogWithMessage(
          title: 'Zajęta nazwa grupy',
          message:
              'Już istnieje grupa o takiej nazwie. Zmień ją aby móc kontynuować operację.',
        );
        break;
    }
  }
}
