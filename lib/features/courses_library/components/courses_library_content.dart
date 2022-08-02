import 'package:fiszkomaniak/features/courses_library/bloc/courses_library_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/empty_content_info.dart';
import 'courses_library_courses_list.dart';

class CoursesLibraryContent extends StatelessWidget {
  const CoursesLibraryContent({super.key});

  @override
  Widget build(BuildContext context) {
    final bool areCourses = context.select(
      (CoursesLibraryBloc bloc) => bloc.state.areCourses,
    );
    if (areCourses) {
      return const CoursesLibraryCoursesList();
    }
    return const _NoCoursesInfo();
  }
}

class _NoCoursesInfo extends StatelessWidget {
  const _NoCoursesInfo();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: EmptyContentInfo(
          icon: MdiIcons.library,
          title: 'Brak utworzonych kursów',
          subtitle:
              'Naciśnij fioletowy przycisk znajdujący się na dolnym pasku aby dodać nowy kurs',
        ),
      ),
    );
  }
}
