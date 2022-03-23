import 'package:fiszkomaniak/core/courses/courses_event.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/courses/courses_bloc.dart';

class CoursesBlocProvider extends StatelessWidget {
  final Widget child;

  const CoursesBlocProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CoursesBloc(
        coursesInterface: context.read<CoursesInterface>(),
      )..add(CoursesEventInitialize()),
      child: child,
    );
  }
}
