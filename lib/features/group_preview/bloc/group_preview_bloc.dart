import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/remove_group_use_case.dart';
import 'package:fiszkomaniak/features/group_preview/group_preview_dialogs.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../domain/entities/flashcard.dart';
import '../../../domain/entities/group.dart';

part 'group_preview_event.dart';

part 'group_preview_state.dart';

class GroupPreviewBloc extends Bloc<GroupPreviewEvent, GroupPreviewState> {
  late final GetGroupUseCase _getGroupUseCase;
  late final RemoveGroupUseCase _removeGroupUseCase;
  late final GetCourseUseCase _getCourseUseCase;
  late final GroupPreviewDialogs _groupPreviewDialogs;
  StreamSubscription<Group>? _groupListener;

  GroupPreviewBloc({
    required GetGroupUseCase getGroupUseCase,
    required RemoveGroupUseCase removeGroupUseCase,
    required GetCourseUseCase getCourseUseCase,
    required GroupPreviewDialogs groupPreviewDialogs,
  }) : super(const GroupPreviewState()) {
    _getGroupUseCase = getGroupUseCase;
    _removeGroupUseCase = removeGroupUseCase;
    _getCourseUseCase = getCourseUseCase;
    _groupPreviewDialogs = groupPreviewDialogs;
    on<GroupPreviewEventInitialize>(_initialize);
    on<GroupPreviewEventGroupUpdated>(_groupUpdated);
    on<GroupPreviewEventCourseChanged>(_courseChanged);
    on<GroupPreviewEventRemoveGroup>(_removeGroup);
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

  void _groupUpdated(
    GroupPreviewEventGroupUpdated event,
    Emitter<GroupPreviewState> emit,
  ) {
    emit(state.copyWith(
      group: event.group,
    ));
  }

  Future<void> _courseChanged(
    GroupPreviewEventCourseChanged event,
    Emitter<GroupPreviewState> emit,
  ) async {
    final Course course =
        await _getCourseUseCase.execute(courseId: event.courseId).first;
    emit(state.copyWith(
      course: course,
    ));
  }

  Future<void> _removeGroup(
    GroupPreviewEventRemoveGroup event,
    Emitter<GroupPreviewState> emit,
  ) async {
    final String? groupId = state.group?.id;
    if (groupId != null && await _isDeleteOperationConfirmed()) {
      emit(state.copyWith(
        status: const BlocStatusLoading(),
      ));
      await _removeGroupUseCase.execute(groupId: groupId);
      emit(state.copyWith(
        status: const BlocStatusComplete(
          info: GroupPreviewInfoType.groupHasBeenRemoved,
        ),
      ));
    }
  }

  void _setGroupListener(String groupId) {
    _groupListener ??= _getGroupUseCase
        .execute(groupId: groupId)
        .doOnData(_updateCourseInStateIfItHasBeenChanged)
        .listen(
          (group) => add(GroupPreviewEventGroupUpdated(group: group)),
        );
  }

  void _updateCourseInStateIfItHasBeenChanged(Group group) {
    if (group.courseId != state.course?.id) {
      add(GroupPreviewEventCourseChanged(courseId: group.courseId));
    }
  }

  Future<bool> _isDeleteOperationConfirmed() async {
    return await _groupPreviewDialogs.askForDeleteConfirmation();
  }
}
