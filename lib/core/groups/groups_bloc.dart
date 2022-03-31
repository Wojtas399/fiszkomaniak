import 'dart:async';
import 'package:fiszkomaniak/core/groups/groups_event.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/core/groups/groups_status.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/models/changed_document.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  late final GroupsInterface _groupsInterface;
  StreamSubscription<List<ChangedDocument<Group>>>? _groupsSubscription;

  GroupsBloc({required GroupsInterface groupsInterface})
      : super(GroupsState()) {
    _groupsInterface = groupsInterface;
    on<GroupsEventInitialize>(_initialize);
    on<GroupsEventGroupAdded>(_groupAdded);
    on<GroupsEventGroupUpdated>(_groupUpdated);
    on<GroupsEventGroupRemoved>(_groupRemoved);
    on<GroupsEventAddGroup>(_addGroup);
    on<GroupsEventUpdateGroup>(_updateGroup);
    on<GroupsEventRemoveGroup>(_removeGroup);
  }

  void _initialize(
    GroupsEventInitialize event,
    Emitter<GroupsState> emit,
  ) {
    _groupsSubscription =
        _groupsInterface.getGroupsSnapshots().listen((groups) {
      for (final group in groups) {
        switch (group.changeType) {
          case DbDocChangeType.added:
            add(GroupsEventGroupAdded(group: group.doc));
            break;
          case DbDocChangeType.updated:
            add(GroupsEventGroupUpdated(group: group.doc));
            break;
          case DbDocChangeType.removed:
            add(GroupsEventGroupRemoved(groupId: group.doc.id));
            break;
        }
      }
    });
  }

  void _groupAdded(
    GroupsEventGroupAdded event,
    Emitter<GroupsState> emit,
  ) {
    emit(state.copyWith(
      allGroups: [...state.allGroups, event.group],
    ));
  }

  void _groupUpdated(
    GroupsEventGroupUpdated event,
    Emitter<GroupsState> emit,
  ) {
    List<Group> allGroups = [...state.allGroups];
    final indexOfUpdatedGroup = allGroups.indexWhere(
      (group) => group.id == event.group.id,
    );
    allGroups[indexOfUpdatedGroup] = event.group;
    emit(state.copyWith(allGroups: allGroups));
  }

  void _groupRemoved(
    GroupsEventGroupRemoved event,
    Emitter<GroupsState> emit,
  ) {
    List<Group> allGroups = [...state.allGroups];
    allGroups.removeWhere((group) => group.id == event.groupId);
    emit(state.copyWith(allGroups: allGroups));
  }

  Future<void> _addGroup(
    GroupsEventAddGroup event,
    Emitter<GroupsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: GroupsStatusLoading()));
      await _groupsInterface.addNewGroup(
        name: event.name,
        courseId: event.courseId,
        nameForQuestions: event.nameForQuestions,
        nameForAnswers: event.nameForAnswers,
      );
      emit(state.copyWith(status: GroupsStatusGroupAdded()));
    } catch (error) {
      emit(
        state.copyWith(status: GroupsStatusError(message: error.toString())),
      );
    }
  }

  Future<void> _updateGroup(
    GroupsEventUpdateGroup event,
    Emitter<GroupsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: GroupsStatusLoading()));
      await _groupsInterface.updateGroup(
        groupId: event.groupId,
        courseId: event.courseId,
        name: event.name,
        nameForQuestion: event.nameForQuestions,
        nameForAnswers: event.nameForAnswers,
      );
      emit(state.copyWith(status: GroupsStatusGroupUpdated()));
    } catch (error) {
      emit(
        state.copyWith(status: GroupsStatusError(message: error.toString())),
      );
    }
  }

  Future<void> _removeGroup(
    GroupsEventRemoveGroup event,
    Emitter<GroupsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: GroupsStatusLoading()));
      await _groupsInterface.removeGroup(event.groupId);
      emit(state.copyWith(status: GroupsStatusGroupRemoved()));
    } catch (error) {
      emit(
        state.copyWith(status: GroupsStatusError(message: error.toString())),
      );
    }
  }

  @override
  Future<void> close() {
    _groupsSubscription?.cancel();
    return super.close();
  }
}
