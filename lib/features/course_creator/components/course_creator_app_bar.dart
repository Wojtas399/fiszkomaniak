import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/app_bar_with_close_button.dart';
import '../bloc/course_creator_bloc.dart';
import '../bloc/course_creator_mode.dart';

class CourseCreatorAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CourseCreatorAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseCreatorBloc, CourseCreatorState>(
      builder: (_, CourseCreatorState state) {
        return CustomAppBar(label: _getTitle(state.mode));
      },
    );
  }

  String _getTitle(CourseCreatorMode mode) {
    if (mode is CourseCreatorCreateMode) {
      return 'Nowy kurs';
    }
    if (mode is CourseCreatorEditMode) {
      return 'Edycja kursu';
    }
    return '';
  }
}
