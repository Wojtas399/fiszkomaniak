import 'package:fiszkomaniak/components/custom_icon_button.dart';
import 'package:fiszkomaniak/components/item_with_icon.dart';
import 'package:fiszkomaniak/components/section.dart';
import 'package:fiszkomaniak/components/select_item/select_item.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_bloc.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/flashcards_type_picker.dart';
import '../../../models/session_model.dart';

class SessionCreatorFlashcards extends StatelessWidget {
  const SessionCreatorFlashcards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCreatorBloc, SessionCreatorState>(
      builder: (BuildContext context, SessionCreatorState state) {
        return Section(
          title: 'Fiszki',
          displayDividerAtTheBottom: true,
          child: Stack(
            children: [
              Column(
                children: [
                  SelectItem(
                    icon: MdiIcons.archiveOutline,
                    value: state.selectedCourse?.name ?? '--',
                    label: 'Kurs',
                    optionsListTitle: 'Wybierz kurs',
                    options: _createCoursesOptions(state),
                    onOptionSelected: (String key, String value) {
                      context
                          .read<SessionCreatorBloc>()
                          .add(SessionCreatorEventCourseSelected(
                            courseId: key,
                          ));
                    },
                  ),
                  SelectItem(
                    icon: MdiIcons.folderOutline,
                    value: state.selectedGroup?.name ?? '--',
                    label: 'Grupa',
                    optionsListTitle: 'Wybierz grupę',
                    options: _createGroupsOptions(state),
                    onOptionSelected: (String key, String value) {
                      context
                          .read<SessionCreatorBloc>()
                          .add(SessionCreatorEventGroupSelected(
                            groupId: key,
                          ));
                    },
                  ),
                  FlashcardsTypePicker(
                    selectedType: state.flashcardsType,
                    availableTypes: state.availableFlashcardsTypes,
                    onTypeChanged: (FlashcardsType type) {
                      context
                          .read<SessionCreatorBloc>()
                          .add(SessionCreatorEventFlashcardsTypeSelected(
                            type: type,
                          ));
                    },
                  ),
                  ItemWithIcon(
                    icon: MdiIcons.fileOutline,
                    label: 'Nazwa dla pytań',
                    text: state.nameForQuestions ?? '--',
                    paddingLeft: 8.0,
                    paddingRight: 8.0,
                  ),
                  ItemWithIcon(
                    icon: MdiIcons.fileReplaceOutline,
                    label: 'Nazwa dla odpowiedzi',
                    text: state.nameForAnswers ?? '--',
                    paddingLeft: 8.0,
                    paddingRight: 8.0,
                  ),
                ],
              ),
              Positioned(
                right: 0.0,
                bottom: 48.0,
                child: CustomIconButton(
                  icon: MdiIcons.swapVertical,
                  onPressed: () {
                    context
                        .read<SessionCreatorBloc>()
                        .add(SessionCreatorEventSwapQuestionsWithAnswers());
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Map<String, String> _createCoursesOptions(SessionCreatorState state) {
    return {for (final course in state.courses) course.id: course.name};
  }

  Map<String, String> _createGroupsOptions(SessionCreatorState state) {
    final List<Group>? groups = state.groups;
    if (groups != null) {
      return {for (final group in groups) group.id: group.name};
    }
    return {};
  }
}
