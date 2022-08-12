import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/navigation.dart';
import '../../providers/dialogs_provider.dart';
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
import 'bloc/group_creator_mode.dart';
import 'components/group_creator_content.dart';

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
    return BlocProvider(
      create: (_) => GroupCreatorBloc(
        getAllCoursesUseCase: GetAllCoursesUseCase(
          coursesInterface: context.read<CoursesInterface>(),
        ),
        loadAllCoursesUseCase: LoadAllCoursesUseCase(
          coursesInterface: context.read<CoursesInterface>(),
        ),
        checkGroupNameUsageInCourseUseCase: CheckGroupNameUsageInCourseUseCase(
          groupsInterface: context.read<GroupsInterface>(),
        ),
        addGroupUseCase: AddGroupUseCase(
          groupsInterface: context.read<GroupsInterface>(),
        ),
        updateGroupUseCase: UpdateGroupUseCase(
          groupsInterface: context.read<GroupsInterface>(),
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
          DialogsProvider.showLoadingDialog();
        } else if (blocStatus is BlocStatusComplete) {
          DialogsProvider.closeLoadingDialog(context);
          final GroupCreatorInfo? info = blocStatus.info;
          if (info != null) {
            _manageInfo(info, context);
          }
        } else if (blocStatus is BlocStatusError) {
          DialogsProvider.closeLoadingDialog(context);
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
    if (info == GroupCreatorInfo.groupHasBeenAdded) {
      Navigation.backHome();
      context.read<HomePageController>().moveToPage(0);
      DialogsProvider.showSnackbarWithMessage('Pomyślnie dodano nową grupę.');
    } else if (info == GroupCreatorInfo.groupHasBeenUpdated) {
      Navigation.moveBack();
      DialogsProvider.showSnackbarWithMessage(
        'Pomyślnie zaktualizaowano grupę.',
      );
    }
  }

  void _manageError(GroupCreatorError error) {
    switch (error) {
      case GroupCreatorError.groupNameIsAlreadyTaken:
        DialogsProvider.showDialogWithMessage(
          title: 'Zajęta nazwa grupy',
          message:
              'Już istnieje grupa o takiej nazwie. Zmień ją aby móc kontynuować operację.',
        );
        break;
    }
  }
}
