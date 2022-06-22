import 'package:fiszkomaniak/components/course_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/bouncing_scroll.dart';
import '../bloc/courses_library_bloc.dart';

class CoursesLibraryCoursesList extends StatelessWidget {
  const CoursesLibraryCoursesList({super.key});

  @override
  Widget build(BuildContext context) {
    return const BouncingScroll(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 16,
            right: 16,
            bottom: 32,
            left: 16,
          ),
          child: _CoursesList(),
        ),
      ),
    );
  }
}

class _CoursesList extends StatelessWidget {
  const _CoursesList();

  @override
  Widget build(BuildContext context) {
    final List<CourseItemParams> coursesItemsParams = context.select(
      (CoursesLibraryBloc bloc) => bloc.state.coursesItemsParams,
    );
    return Column(
      children: coursesItemsParams
          .map((params) => CourseItem(params: params))
          .toList(),
    );
  }
}
