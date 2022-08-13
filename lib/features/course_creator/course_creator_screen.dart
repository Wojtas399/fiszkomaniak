import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/navigation.dart';
import '../../providers/dialogs_provider.dart';
import '../../domain/use_cases/courses/add_new_course_use_case.dart';
import '../../domain/use_cases/courses/check_course_name_usage_use_case.dart';
import '../../domain/use_cases/courses/update_course_name_use_case.dart';
import '../../interfaces/courses_interface.dart';
import '../../models/bloc_status.dart';
import '../home/home.dart';
import 'bloc/course_creator_bloc.dart';
import 'bloc/course_creator_mode.dart';
import 'components/course_creator_app_bar.dart';
import 'components/course_creator_content.dart';

class CourseCreatorScreen extends StatelessWidget {
  final CourseCreatorMode mode;

  const CourseCreatorScreen({super.key, required this.mode});

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
        final BlocStatus blocStatus = state.status;
        if (blocStatus is BlocStatusLoading) {
          DialogsProvider.showLoadingDialog();
        } else if (blocStatus is BlocStatusComplete) {
          DialogsProvider.closeLoadingDialog(context);
          final CourseCreatorInfo? info = blocStatus.info;
          if (info != null) {
            _manageInfo(blocStatus.info, context);
          }
        } else if (blocStatus is BlocStatusError) {
          DialogsProvider.closeLoadingDialog(context);
          final CourseCreatorError? error = blocStatus.error;
          if (error != null) {
            _manageError(error);
          }
        }
      },
      child: child,
    );
  }

  void _manageInfo(CourseCreatorInfo info, BuildContext context) {
    switch (info) {
      case CourseCreatorInfo.courseHasBeenAdded:
        Navigation.backHome();
        context.read<HomePageController>().moveToPage(2);
        DialogsProvider.showSnackbarWithMessage('Pomyślnie dodano nowy kurs');
        break;
      case CourseCreatorInfo.courseHasBeenUpdated:
        Navigation.backHome();
        context.read<HomePageController>().moveToPage(2);
        DialogsProvider.showSnackbarWithMessage(
          'Pomyślnie zaktualizowano kurs',
        );
        break;
    }
  }

  void _manageError(CourseCreatorError error) {
    switch (error) {
      case CourseCreatorError.courseNameIsAlreadyTaken:
        DialogsProvider.showDialogWithMessage(
          title: 'Zajęta nazwa',
          message:
              'Kurs o podanej nazwie już istnieje. Spróbuj wpisać inną nazwę.',
        );
        break;
    }
  }
}
