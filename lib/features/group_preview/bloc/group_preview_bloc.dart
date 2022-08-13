import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/entities/flashcard.dart';
import '../../../domain/entities/group.dart';
import '../../../domain/use_cases/courses/get_course_use_case.dart';
import '../../../domain/use_cases/groups/get_group_use_case.dart';
import '../../../domain/use_cases/groups/delete_group_use_case.dart';
import '../../../models/bloc_status.dart';

part 'group_preview_event.dart';

part 'group_preview_state.dart';

class GroupPreviewBloc extends Bloc<GroupPreviewEvent, GroupPreviewState> {
  late final GetGroupUseCase _getGroupUseCase;
  late final DeleteGroupUseCase _deleteGroupUseCase;
  late final GetCourseUseCase _getCourseUseCase;
  StreamSubscription<Group>? _groupListener;

  GroupPreviewBloc({
    required GetGroupUseCase getGroupUseCase,
    required DeleteGroupUseCase deleteGroupUseCase,
    required GetCourseUseCase getCourseUseCase,
    BlocStatus status = const BlocStatusInitial(),
    Group? group,
    Course? course,
  }) : super(
          GroupPreviewState(
            status: status,
            group: group,
            course: course,
          ),
        ) {
    _getGroupUseCase = getGroupUseCase;
    _deleteGroupUseCase = deleteGroupUseCase;
    _getCourseUseCase = getCourseUseCase;
    on<GroupPreviewEventInitialize>(_initialize);
    on<GroupPreviewEventGroupUpdated>(_groupUpdated);
    on<GroupPreviewEventDeleteGroup>(_deleteGroup);
  }

  @override
  Future<void> close() {
    _groupListener?.cancel();
    return super.close();
  }

  void _initialize(
    GroupPreviewEventInitialize event,
    Emitter<GroupPreviewState> emit,
  ) {
    _setGroupListener(event.groupId);
  }

  Future<void> _groupUpdated(
    GroupPreviewEventGroupUpdated event,
    Emitter<GroupPreviewState> emit,
  ) async {
    final Group updatedGroup = event.group;
    final String newCourseId = updatedGroup.courseId;
    if (newCourseId != state.course?.id) {
      emit(state.copyWith(
        group: updatedGroup,
        course: await _getCourseUseCase.execute(courseId: newCourseId).first,
      ));
    } else {
      emit(state.copyWith(
        group: updatedGroup,
      ));
    }
  }

  Future<void> _deleteGroup(
    GroupPreviewEventDeleteGroup event,
    Emitter<GroupPreviewState> emit,
  ) async {
    final String? groupId = state.group?.id;
    if (groupId != null) {
      emit(state.copyWith(
        status: const BlocStatusLoading(),
      ));
      await _deleteGroupUseCase.execute(groupId: groupId);
      emit(state.copyWithInfo(
        GroupPreviewInfo.groupHasBeenDeleted,
      ));
    }
  }

  void _setGroupListener(String groupId) {
    _groupListener ??= _getGroupUseCase
        .execute(groupId: groupId)
        .listen((group) => add(GroupPreviewEventGroupUpdated(group: group)));
  }
}
