import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_bloc.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/app_bar_with_close_button.dart';

class CourseCreatorAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CourseCreatorAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseCreatorBloc, CourseCreatorState>(
      builder: (_, CourseCreatorState state) {
        return AppBarWithCloseButton(label: state.title);
      },
    );
  }
}
