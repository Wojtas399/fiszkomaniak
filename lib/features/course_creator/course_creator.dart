import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/add_new_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/check_course_name_usage_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/update_course_name_use_case.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_bloc.dart';
import 'package:fiszkomaniak/features/course_creator/components/course_creator_app_bar.dart';
import 'package:fiszkomaniak/features/course_creator/components/course_creator_content.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_mode.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../home/home.dart';

class CourseCreator extends StatelessWidget {
  final CourseCreatorMode mode;

  const CourseCreator({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return _CourseCreatorBlocProvider(
      mode: mode,
      child: _CourseCreatorBlocListener(
        child: Scaffold(
          appBar: const CourseCreatorAppBar(),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: CourseCreatorContent(),
            ),
          ),
        ),
      ),
    );
  }
}

class _CourseCreatorBlocProvider extends StatelessWidget {
  final CourseCreatorMode mode;
  final Widget child;

  const _CourseCreatorBlocProvider({
    required this.mode,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final CoursesInterface coursesInterface = context.read<CoursesInterface>();
    return BlocProvider(
      create: (BuildContext context) => CourseCreatorBloc(
        addNewCourseUseCase: AddNewCourseUseCase(
          coursesInterface: coursesInterface,
        ),
        checkCourseNameUsageUseCase: CheckCourseNameUsageUseCase(
          coursesInterface: coursesInterface,
        ),
        updateCourseNameUseCase: UpdateCourseNameUseCase(
          coursesInterface: coursesInterface,
        ),
      )..add(CourseCreatorEventInitialize(mode: mode)),
      child: child,
    );
  }
}

class _CourseCreatorBlocListener extends StatelessWidget {
  final Widget child;

  const _CourseCreatorBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CourseCreatorBloc, CourseCreatorState>(
      listener: (BuildContext context, CourseCreatorState state) {
        final CourseCreatorStatus status = state.status;
        if (status is CourseCreatorStatusLoading) {
          Dialogs.showLoadingDialog();
        } else if (status is CourseCreatorStatusCourseNameIsAlreadyTaken) {
          Dialogs.closeLoadingDialog(context);
          Dialogs.showDialogWithMessage(
            title: 'Zajęta nazwa',
            message:
                'Kurs o podanej nazwie już istnieje. Spróbuj wpisać inną nazwę.',
          );
        } else if (status is CourseCreatorStatusCourseAdded) {
          Dialogs.closeLoadingDialog(context);
          context.read<Navigation>().backHome();
          context.read<HomePageController>().moveToPage(2);
          Dialogs.showSnackbarWithMessage('Pomyślnie dodano nowy kurs');
        } else if (status is CourseCreatorStatusCourseUpdated) {
          Dialogs.closeLoadingDialog(context);
          context.read<Navigation>().backHome();
          context.read<HomePageController>().moveToPage(2);
          Dialogs.showSnackbarWithMessage('Pomyślnie zaktualizowano kurs');
        }
      },
      child: child,
    );
  }
}
