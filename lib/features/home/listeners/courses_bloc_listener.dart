import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/dialogs/dialogs.dart';
import '../../../config/navigation.dart';

class CoursesBlocListener extends BlocListener<CoursesBloc, CoursesState> {
  final Function(int pageIndex) onHomePageChanged;

  CoursesBlocListener({
    super.key,
    required this.onHomePageChanged,
  }) : super(
          listener: (BuildContext context, CoursesState state) {
            final CoursesStatus status = state.status;
            if (status is CoursesStatusLoading) {
              Dialogs.showLoadingDialog();
            } else if (status is CoursesStatusCourseAdded) {
              Dialogs.closeLoadingDialog(context);
              context.read<Navigation>().backHome();
              Dialogs.showSnackbarWithMessage('Pomyślnie dodano nowy kurs');
              onHomePageChanged(2);
            } else if (status is CoursesStatusCourseUpdated) {
              Dialogs.closeLoadingDialog(context);
              context.read<Navigation>().backHome();
              Dialogs.showSnackbarWithMessage('Pomyślnie zaktualizowano kurs');
            } else if (status is CoursesStatusCourseRemoved) {
              Dialogs.closeLoadingDialog(context);
              Dialogs.showSnackbarWithMessage('Pomyślnie usunięto kurs');
            } else if (status is CoursesStatusError) {
              Dialogs.closeLoadingDialog(context);
              Dialogs.showErrorDialog(message: status.message);
            }
          },
        );
}
