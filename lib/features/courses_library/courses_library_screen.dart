import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../providers/dialogs_provider.dart';
import '../../domain/use_cases/courses/delete_course_use_case.dart';
import '../../domain/use_cases/courses/get_all_courses_use_case.dart';
import '../../domain/use_cases/courses/load_all_courses_use_case.dart';
import '../../interfaces/courses_interface.dart';
import '../../models/bloc_status.dart';
import 'bloc/courses_library_bloc.dart';
import 'components/courses_library_content.dart';

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
    return BlocProvider(
      create: (BuildContext context) => CoursesLibraryBloc(
        getAllCoursesUseCase: GetAllCoursesUseCase(
          coursesInterface: context.read<CoursesInterface>(),
        ),
        loadAllCoursesUseCase: LoadAllCoursesUseCase(
          coursesInterface: context.read<CoursesInterface>(),
        ),
        deleteCourseUseCase: DeleteCourseUseCase(
          coursesInterface: context.read<CoursesInterface>(),
        ),
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
          DialogsProvider.showLoadingDialog();
        } else if (blocStatus is BlocStatusComplete) {
          DialogsProvider.closeLoadingDialog(context);
          final CoursesLibraryInfo? info = blocStatus.info;
          if (info != null) {
            _manageInfo(blocStatus.info);
          }
        }
      },
      child: child,
    );
  }

  void _manageInfo(CoursesLibraryInfo info) {
    switch (info) {
      case CoursesLibraryInfo.courseHasBeenRemoved:
        DialogsProvider.showSnackbarWithMessage('Pomyślnie usunięto kurs');
        break;
    }
  }
}
