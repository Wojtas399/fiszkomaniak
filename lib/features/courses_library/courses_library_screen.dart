import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/load_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/remove_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_groups_by_course_id_use_case.dart';
import 'package:fiszkomaniak/features/courses_library/bloc/courses_library_bloc.dart';
import 'package:fiszkomaniak/features/courses_library/components/courses_library_content.dart';
import 'package:fiszkomaniak/features/courses_library/courses_library_dialogs.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoursesLibraryScreen extends StatelessWidget {
  const CoursesLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CoursesLibraryBlocProvider(
      child: _CoursesLibraryBlocListener(
        child: CoursesLibraryContent(),
      ),
    );
  }
}

class _CoursesLibraryBlocProvider extends StatelessWidget {
  final Widget child;

  const _CoursesLibraryBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    final coursesInterface = context.read<CoursesInterface>();
    return BlocProvider(
      create: (BuildContext context) => CoursesLibraryBloc(
        getAllCoursesUseCase: GetAllCoursesUseCase(
          coursesInterface: coursesInterface,
        ),
        loadAllCoursesUseCase: LoadAllCoursesUseCase(
          coursesInterface: coursesInterface,
        ),
        removeCourseUseCase: RemoveCourseUseCase(
          coursesInterface: coursesInterface,
        ),
        getGroupsByCourseIdUseCase: GetGroupsByCourseIdUseCase(
          groupsInterface: context.read<GroupsInterface>(),
        ),
        coursesLibraryDialogs: CoursesLibraryDialogs(),
        navigation: context.read<Navigation>(),
      )..add(CoursesLibraryEventInitialize()),
      child: child,
    );
  }
}

class _CoursesLibraryBlocListener extends StatelessWidget {
  final Widget child;

  const _CoursesLibraryBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoursesLibraryBloc, CoursesLibraryState>(
      listener: (BuildContext context, CoursesLibraryState state) {
        final BlocStatus blocStatus = state.status;
        if (blocStatus is BlocStatusLoading) {
          Dialogs.showLoadingDialog();
        } else if (blocStatus is BlocStatusComplete) {
          Dialogs.closeLoadingDialog(context);
          final CoursesLibraryInfoType? info = blocStatus.info;
          if (info != null) {
            _displayAppropriateInfo(blocStatus.info, context);
          }
        }
      },
      child: child,
    );
  }

  void _displayAppropriateInfo(
    CoursesLibraryInfoType infoType,
    BuildContext context,
  ) {
    switch (infoType) {
      case CoursesLibraryInfoType.courseHasBeenRemoved:
        Dialogs.showSnackbarWithMessage('Pomyślnie usunięto kurs');
        break;
    }
  }
}
