import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/item_with_icon.dart';
import '../../../components/section.dart';
import '../../../core/courses/courses_state.dart';

class GroupPreviewInformation extends StatelessWidget {
  final String courseId;
  final String nameForQuestions;
  final String nameForAnswers;

  const GroupPreviewInformation({
    Key? key,
    required this.courseId,
    required this.nameForQuestions,
    required this.nameForAnswers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (BuildContext context, CoursesState coursesState) {
        return Section(
          title: 'Informacje',
          displayDividerAtTheBottom: true,
          child: Column(
            children: [
              ItemWithIcon(
                icon: MdiIcons.archiveOutline,
                label: 'Kurs',
                text: coursesState.getCourseNameById(courseId),
              ),
              ItemWithIcon(
                icon: MdiIcons.fileOutline,
                label: 'Pytania',
                text: nameForQuestions,
              ),
              ItemWithIcon(
                icon: MdiIcons.fileReplaceOutline,
                label: 'Odpowiedzi',
                text: nameForAnswers,
              ),
            ],
          ),
        );
      },
    );
  }
}
