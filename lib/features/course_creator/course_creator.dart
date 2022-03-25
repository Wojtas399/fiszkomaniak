import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_bloc.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_event.dart';
import 'package:fiszkomaniak/features/course_creator/components/course_creator_app_bar.dart';
import 'package:fiszkomaniak/features/course_creator/components/course_creator_content.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_arguments.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/courses/courses_bloc.dart';
import 'bloc/course_creator_state.dart';

class CourseCreator extends StatelessWidget {
  final CourseCreatorMode mode;

  const CourseCreator({
    Key? key,
    required this.mode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CourseCreatorBloc(
        coursesBloc: context.read<CoursesBloc>(),
      )..add(CourseCreatorEventInitialize(mode: mode)),
      child: Scaffold(
        appBar: const CourseCreatorAppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _StatusListener(
              child: CourseCreatorContent(),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusListener extends StatelessWidget {
  final Widget child;

  const _StatusListener({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<CourseCreatorBloc, CourseCreatorState>(
      listener: (BuildContext context, CourseCreatorState state) {
        HttpStatus status = state.httpStatus;
        if (status is HttpStatusSubmitting) {
          Dialogs.showLoadingDialog(context: context);
        } else if (status is HttpStatusSuccess) {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.pop(context);
        } else if (status is HttpStatusFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          Dialogs.showDialogWithMessage(
            context: context,
            title: 'Wystąpił błąd...',
            message: status.message,
          );
        }
      },
      child: child,
    );
  }
}
