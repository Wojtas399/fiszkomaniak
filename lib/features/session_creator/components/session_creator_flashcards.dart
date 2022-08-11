import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/custom_icon_button.dart';
import '../../../components/flashcards_type_picker.dart';
import '../../../components/item_with_icon.dart';
import '../../../components/section.dart';
import '../../../components/select_item/select_item.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/entities/group.dart';
import '../../../domain/entities/session.dart';
import '../bloc/session_creator_bloc.dart';

class SessionCreatorFlashcards extends StatelessWidget {
  const SessionCreatorFlashcards({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Fiszki',
      displayDividerAtTheBottom: true,
      child: Stack(
        children: [
          Column(
            children: const [
              _CourseSelector(),
              _GroupSelector(),
              _FlashcardsTypeSelector(),
              _NameForQuestions(),
              _NameForAnswers(),
            ],
          ),
          const _QuestionsAndAnswersSwapButton(),
        ],
      ),
    );
  }
}

class _CourseSelector extends StatelessWidget {
  const _CourseSelector();

  @override
  Widget build(BuildContext context) {
    final Course? selectedCourse = context.select(
      (SessionCreatorBloc bloc) => bloc.state.selectedCourse,
    );
    final List<Course> coursesToSelect = context.select(
      (SessionCreatorBloc bloc) => bloc.state.courses,
    );
    return SelectItem(
      icon: MdiIcons.archiveOutline,
      value: selectedCourse?.name ?? '--',
      label: 'Kurs',
      optionsListTitle: 'Wybierz kurs',
      options: _createCoursesOptions(coursesToSelect),
      onOptionSelected: (String courseId, _) => _onSelected(courseId, context),
    );
  }

  Map<String, String> _createCoursesOptions(List<Course> courses) {
    return {for (final course in courses) course.id: course.name};
  }

  void _onSelected(String courseId, BuildContext context) {
    context
        .read<SessionCreatorBloc>()
        .add(SessionCreatorEventCourseSelected(courseId: courseId));
  }
}

class _GroupSelector extends StatelessWidget {
  const _GroupSelector();

  @override
  Widget build(BuildContext context) {
    final Group? selectedGroup = context.select(
      (SessionCreatorBloc bloc) => bloc.state.selectedGroup,
    );
    final List<Group>? groupsToSelect = context.select(
      (SessionCreatorBloc bloc) => bloc.state.groups,
    );
    return SelectItem(
      icon: MdiIcons.folderOutline,
      value: selectedGroup?.name ?? '--',
      label: 'Grupa',
      optionsListTitle: 'Wybierz grupę',
      options: _createGroupsOptions(groupsToSelect),
      onOptionSelected: (String groupId, _) => _onSelected(groupId, context),
    );
  }

  Map<String, String> _createGroupsOptions(List<Group>? groups) {
    if (groups != null) {
      return {for (final group in groups) group.id: group.name};
    }
    return {};
  }

  void _onSelected(String groupId, BuildContext context) {
    context
        .read<SessionCreatorBloc>()
        .add(SessionCreatorEventGroupSelected(groupId: groupId));
  }
}

class _FlashcardsTypeSelector extends StatelessWidget {
  const _FlashcardsTypeSelector();

  @override
  Widget build(BuildContext context) {
    final FlashcardsType selectedFlashcardsType = context.select(
      (SessionCreatorBloc bloc) => bloc.state.flashcardsType,
    );
    final List<FlashcardsType> availableFlashcardsTypes = context.select(
      (SessionCreatorBloc bloc) => bloc.state.availableFlashcardsTypes,
    );
    return FlashcardsTypePicker(
      selectedType: selectedFlashcardsType,
      availableTypes: availableFlashcardsTypes,
      onTypeChanged: (FlashcardsType type) => _onTypeChanged(type, context),
    );
  }

  void _onTypeChanged(FlashcardsType type, BuildContext context) {
    context
        .read<SessionCreatorBloc>()
        .add(SessionCreatorEventFlashcardsTypeSelected(type: type));
  }
}

class _NameForQuestions extends StatelessWidget {
  const _NameForQuestions();

  @override
  Widget build(BuildContext context) {
    final String? nameForQuestions = context.select(
      (SessionCreatorBloc bloc) => bloc.state.nameForQuestions,
    );
    return ItemWithIcon(
      icon: MdiIcons.fileOutline,
      label: 'Nazwa dla pytań',
      text: nameForQuestions ?? '--',
      paddingLeft: 8.0,
      paddingRight: 8.0,
    );
  }
}

class _NameForAnswers extends StatelessWidget {
  const _NameForAnswers();

  @override
  Widget build(BuildContext context) {
    final String? nameForAnswers = context.select(
      (SessionCreatorBloc bloc) => bloc.state.nameForAnswers,
    );
    return ItemWithIcon(
      icon: MdiIcons.fileReplaceOutline,
      label: 'Nazwa dla odpowiedzi',
      text: nameForAnswers ?? '--',
      paddingLeft: 8.0,
      paddingRight: 8.0,
    );
  }
}

class _QuestionsAndAnswersSwapButton extends StatelessWidget {
  const _QuestionsAndAnswersSwapButton();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0.0,
      bottom: 48.0,
      child: CustomIconButton(
        icon: MdiIcons.swapVertical,
        onPressed: () => _onPressed(context),
      ),
    );
  }

  void _onPressed(BuildContext context) {
    context
        .read<SessionCreatorBloc>()
        .add(SessionCreatorEventSwapQuestionsWithAnswers());
  }
}
