import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_dialogs.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_event.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_mode.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_state.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupCreatorBloc extends Bloc<GroupCreatorEvent, GroupCreatorState> {
  late final CoursesBloc _coursesBloc;
  late final GroupsBloc _groupsBloc;
  late final GroupCreatorDialogs _groupCreatorDialogs;

  GroupCreatorBloc({
    required CoursesBloc coursesBloc,
    required GroupsBloc groupsBloc,
    required GroupCreatorDialogs groupCreatorDialogs,
  }) : super(const GroupCreatorState()) {
    _coursesBloc = coursesBloc;
    _groupsBloc = groupsBloc;
    _groupCreatorDialogs = groupCreatorDialogs;
    on<GroupCreatorEventInitialize>(_initialize);
    on<GroupCreatorEventCourseChanged>(_onCourseChanged);
    on<GroupCreatorEventGroupNameChanged>(_onGroupNameChanged);
    on<GroupCreatorEventNameForQuestionsChanged>(_onNameForQuestionsChanged);
    on<GroupCreatorEventNameForAnswersChanged>(_onNameForAnswersChanged);
    on<GroupCreatorEventSubmit>(_submit);
  }

  void _initialize(
    GroupCreatorEventInitialize event,
    Emitter<GroupCreatorState> emit,
  ) {
    final List<Course> allCourses = _coursesBloc.state.allCourses;
    final GroupCreatorMode mode = event.mode;
    if (mode is GroupCreatorCreateMode) {
      emit(state.copyWith(
        mode: mode,
        allCourses: allCourses,
      ));
    } else if (mode is GroupCreatorEditMode) {
      emit(state.copyWith(
        mode: mode,
        selectedCourse: allCourses.firstWhere(
          (course) => course.id == mode.group.courseId,
        ),
        allCourses: allCourses,
        groupName: mode.group.name,
        nameForQuestions: mode.group.nameForQuestions,
        nameForAnswers: mode.group.nameForAnswers,
      ));
    }
  }

  void _onCourseChanged(
    GroupCreatorEventCourseChanged event,
    Emitter<GroupCreatorState> emit,
  ) {
    emit(state.copyWith(selectedCourse: event.course));
  }

  void _onGroupNameChanged(
    GroupCreatorEventGroupNameChanged event,
    Emitter<GroupCreatorState> emit,
  ) {
    emit(state.copyWith(groupName: event.groupName));
  }

  void _onNameForQuestionsChanged(
    GroupCreatorEventNameForQuestionsChanged event,
    Emitter<GroupCreatorState> emit,
  ) {
    emit(state.copyWith(nameForQuestions: event.nameForQuestions));
  }

  void _onNameForAnswersChanged(
    GroupCreatorEventNameForAnswersChanged event,
    Emitter<GroupCreatorState> emit,
  ) {
    emit(state.copyWith(nameForAnswers: event.nameForAnswers));
  }

  void _submit(
    GroupCreatorEventSubmit event,
    Emitter<GroupCreatorState> emit,
  ) {
    final Course? selectedCourse = state.selectedCourse;
    final String groupName = state.groupName.trim();
    final String nameForQuestions = state.nameForQuestions.trim();
    final String nameForAnswers = state.nameForAnswers.trim();
    if (selectedCourse != null) {
      if (_groupsBloc.state.isThereGroupWithTheSameNameInTheSameCourse(
        groupName,
        selectedCourse.id,
      )) {
        _groupCreatorDialogs.displayInfoAboutAlreadyTakenGroupNameInCourse();
      } else {
        final GroupCreatorMode mode = state.mode;
        if (mode is GroupCreatorCreateMode) {
          _groupsBloc.add(GroupsEventAddGroup(
            name: groupName,
            courseId: selectedCourse.id,
            nameForQuestions: nameForQuestions,
            nameForAnswers: nameForAnswers,
          ));
        } else if (mode is GroupCreatorEditMode) {
          _groupsBloc.add(GroupsEventUpdateGroup(
            groupId: mode.group.id,
            name: groupName,
            courseId: selectedCourse.id,
            nameForQuestions: nameForQuestions,
            nameForAnswers: nameForAnswers,
          ));
        }
      }
    }
  }
}
