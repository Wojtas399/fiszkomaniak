import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_bloc.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_event.dart';
import 'package:fiszkomaniak/features/course_creator/components/course_creator_app_bar.dart';
import 'package:fiszkomaniak/features/course_creator/components/course_creator_content.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseCreator extends StatelessWidget {
  final CourseCreatorMode mode;

  const CourseCreator({
    Key? key,
    required this.mode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CourseCreatorBloc()..add(CourseCreatorEventInitialize(mode: mode)),
      child: Scaffold(
        appBar: const CourseCreatorAppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: CourseCreatorContent(),
          ),
        ),
      ),
    );
  }
}
