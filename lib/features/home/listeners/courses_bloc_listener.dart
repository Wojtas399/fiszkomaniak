import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/dialogs/dialogs.dart';
import '../../../config/navigation.dart';
import '../../../core/courses/courses_status.dart';

class CoursesBlocListener extends BlocListener<CoursesBloc, CoursesState> {
  final Function(int pageIndex) onHomePageChanged;

  CoursesBlocListener({
    Key? key,
    required this.onHomePageChanged,
  }) : super(
          key: key,
          listener: (BuildContext context, CoursesState state) {
            final CoursesStatus status = state.status;
            void closeLoadingDialog() {
              Navigator.of(context, rootNavigator: true).pop();
            }

            if (status is CoursesStatusLoading) {
              Dialogs.showLoadingDialog();
            } else if (status is CoursesStatusCourseAdded) {
              closeLoadingDialog();
              context.read<Navigation>().backHome();
              Dialogs.showSnackbarWithMessage('Pomyślnie dodano nowy kurs');
              onHomePageChanged(2);
            } else if (status is CoursesStatusCourseUpdated) {
              closeLoadingDialog();
              context.read<Navigation>().backHome();
              Dialogs.showSnackbarWithMessage('Pomyślnie zaktualizowano kurs');
            } else if (status is CoursesStatusCourseRemoved) {
              closeLoadingDialog();
              Dialogs.showSnackbarWithMessage('Pomyślnie usunięto kurs');
            } else if (status is CoursesStatusError) {
              closeLoadingDialog();
              Dialogs.showErrorDialog(message: status.message);
            }
          },
        );
}
