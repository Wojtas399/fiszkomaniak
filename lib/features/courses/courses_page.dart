import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/features/courses/components/courses_course_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (BuildContext context, CoursesState state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: state.allCourses
                  .map((course) => CoursesCourseItem(
                        title: course.name,
                        amountOfGroups: 4,
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
