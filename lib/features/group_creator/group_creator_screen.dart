import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/components/on_tap_focus_lose_area.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/load_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/add_group_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/check_group_name_usage_in_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/update_group_use_case.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_bloc.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_mode.dart';
import 'package:fiszkomaniak/features/group_creator/components/group_creator_app_bar.dart';
import 'package:fiszkomaniak/features/group_creator/components/group_creator_course_selection.dart';
import 'package:fiszkomaniak/features/group_creator/components/group_creator_group_info.dart';
import 'package:fiszkomaniak/features/group_creator/components/group_creator_submit_button.dart';
import 'package:fiszkomaniak/features/home/home.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupCreatorScreen extends StatelessWidget {
  final GroupCreatorMode mode;

  const GroupCreatorScreen({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return _GroupCreatorBlocProvider(
      mode: mode,
      child: _GroupCreatorBlocListener(
        child: Scaffold(
          appBar: const GroupCreatorAppBar(),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: OnTapFocusLoseArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const GroupCreatorCourseSelection(),
                        const SizedBox(height: 24),
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
          final info = blocStatus.info;
          if (info != null) {
            _manageBlocInfo(context, info);
          }
        }
      },
      child: child,
    );
  }

  void _manageBlocInfo(BuildContext context, GroupCreatorInfoType info) {
    switch (info) {
      case GroupCreatorInfoType.groupNameIsAlreadyTaken:
        Dialogs.showDialogWithMessage(
          title: 'Zajęta nazwa grupy',
          message:
              'Już istnieje grupa o takiej nazwie. Zmień ją aby móc kontynuować operację.',
        );
        break;
      case GroupCreatorInfoType.groupHasBeenAdded:
        context.read<Navigation>().backHome();
        context.read<HomePageController>().moveToPage(0);
        Dialogs.showSnackbarWithMessage('Pomyślnie dodano nową grupę.');
        break;
      case GroupCreatorInfoType.groupHasBeenEdited:
        context.read<Navigation>().moveBack();
        Dialogs.showSnackbarWithMessage('Pomyślnie zaktualizaowano grupę.');
        break;
    }
  }
}
