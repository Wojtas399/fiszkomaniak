import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_all_groups_use_case.dart';
import 'package:fiszkomaniak/features/study/bloc/study_bloc.dart';
import 'package:fiszkomaniak/features/study/components/study_content.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../interfaces/groups_interface.dart';

class StudyScreen extends StatelessWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StudyBlocProvider(
      child: StudyContent(),
    );
  }
}

class _StudyBlocProvider extends StatelessWidget {
  final Widget child;

  const _StudyBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    final GroupsInterface groupsInterface = context.read<GroupsInterface>();
    return BlocProvider(
      create: (BuildContext context) => StudyBloc(
        getAllGroupsUseCase: GetAllGroupsUseCase(
          groupsInterface: groupsInterface,
        ),
        getCourseUseCase: GetCourseUseCase(
          coursesInterface: context.read<CoursesInterface>(),
        ),
      )..add(StudyEventInitialize()),
      child: child,
    );
  }
}
