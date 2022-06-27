import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/load_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_groups_by_course_id_use_case.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/course.dart';
import '../../../models/flashcard_model.dart';
import '../../../domain/entities/group.dart';

part 'group_selection_event.dart';

part 'group_selection_state.dart';

class GroupSelectionBloc
    extends Bloc<GroupSelectionEvent, GroupSelectionState> {
  late final LoadAllCoursesUseCase _loadAllCoursesUseCase;
  late final GetAllCoursesUseCase _getAllCoursesUseCase;
  late final GetCourseUseCase _getCourseUseCase;
  late final GetGroupsByCourseIdUseCase _getGroupsByCourseIdUseCase;
  late final GetGroupUseCase _getGroupUseCase;
  StreamSubscription<Group>? _groupListener;

  GroupSelectionBloc({
    required LoadAllCoursesUseCase loadAllCoursesUseCase,
    required GetAllCoursesUseCase getAllCoursesUseCase,
    required GetCourseUseCase getCourseUseCase,
    required GetGroupsByCourseIdUseCase getGroupsByCourseIdUseCase,
    required GetGroupUseCase getGroupUseCase,
  }) : super(GroupSelectionState()) {
    _loadAllCoursesUseCase = loadAllCoursesUseCase;
    _getAllCoursesUseCase = getAllCoursesUseCase;
    _getCourseUseCase = getCourseUseCase;
    _getGroupsByCourseIdUseCase = getGroupsByCourseIdUseCase;
    _getGroupUseCase = getGroupUseCase;
    on<GroupSelectionEventInitialize>(_initialize);
    on<GroupSelectionEventCourseSelected>(_courseSelected);
    on<GroupSelectionEventGroupSelected>(_groupSelected);
    on<GroupSelectionEventGroupUpdated>(_groupUpdated);
  }

  @override
  Future<void> close() {
    _cancelGroupListener();
    return super.close();
  }

  Future<void> _initialize(
    GroupSelectionEventInitialize event,
    Emitter<GroupSelectionState> emit,
  ) async {
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    await _loadAllCoursesUseCase.execute();
    final List<Course> allCourses = await _getAllCoursesUseCase.execute().first;
    emit(state.copyWith(
      allCourses: allCourses,
      status: const BlocStatusComplete(),
    ));
  }

  Future<void> _courseSelected(
    GroupSelectionEventCourseSelected event,
    Emitter<GroupSelectionState> emit,
  ) async {
    final Course selectedCourse =
        await _getCourseUseCase.execute(courseId: event.courseId).first;
    final List<Group> groupsFromCourse = await _getGroupsByCourseIdUseCase
        .execute(courseId: event.courseId)
        .first;
    emit(state.copyWith(
      selectedCourse: selectedCourse,
      groupsFromCourse: groupsFromCourse,
    ));
  }

  Future<void> _groupSelected(
    GroupSelectionEventGroupSelected event,
    Emitter<GroupSelectionState> emit,
  ) async {
    _cancelGroupListener();
    _setGroupListener(event.groupId);
  }

  void _groupUpdated(
    GroupSelectionEventGroupUpdated event,
    Emitter<GroupSelectionState> emit,
  ) {
    emit(state.copyWith(
      selectedGroup: event.group,
    ));
  }

  void _setGroupListener(String groupId) {
    _groupListener ??= _getGroupUseCase.execute(groupId: groupId).listen(
          (group) => add(GroupSelectionEventGroupUpdated(group: group)),
        );
  }

  void _cancelGroupListener() {
    _groupListener?.cancel();
    _groupListener = null;
  }
}
