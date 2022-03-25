import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_event.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_arguments.dart';
import 'package:fiszkomaniak/features/courses/components/courses_course_item.dart';
import 'package:fiszkomaniak/features/courses/components/courses_course_popup_menu.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/course_model.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoursesBloc, CoursesState>(
      listener: (BuildContext context, CoursesState state) {
        HttpStatus status = state.httpStatus;
        if (status is HttpStatusSubmitting) {
          Dialogs.showLoadingDialog(context: context);
        } else if (status is HttpStatusSuccess) {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.of(context).popUntil(ModalRoute.withName('/'));
          final String? message = status.message;
          if (message != null) {
            Dialogs.showSnackbarWithMessage(context: context, message: message);
          }
        } else if (status is HttpStatusFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          Dialogs.showDialogWithMessage(
            context: context,
            title: 'Wystąpił błąd...',
            message: status.message,
          );
        }
      },
      builder: (BuildContext context, CoursesState state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: state.allCourses
                  .map((course) => CoursesCourseItem(
                        title: course.name,
                        amountOfGroups: 4,
                        onActionSelected: (CoursePopupAction action) {
                          _manageCourseAction(context, action, course);
                        },
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  void _manageCourseAction(
    BuildContext context,
    CoursePopupAction action,
    Course course,
  ) {
    switch (action) {
      case CoursePopupAction.edit:
        Navigation.navigateToCourseCreator(
          CourseCreatorEditMode(
            courseId: course.id,
            courseName: course.name,
          ),
        );
        break;
      case CoursePopupAction.remove:
        context
            .read<CoursesBloc>()
            .add(CoursesEventRemoveCourse(courseId: course.id));
        break;
    }
  }
}
