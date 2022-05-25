import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/core/initialization_status.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/models/changed_document.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'groups_event.dart';

part 'groups_state.dart';

part 'groups_status.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  late final GroupsInterface _groupsInterface;
  StreamSubscription<List<ChangedDocument<Group>>>? _groupsSubscription;

  GroupsBloc({
    required GroupsInterface groupsInterface,
  }) : super(const GroupsState()) {
    _groupsInterface = groupsInterface;
    on<GroupsEventInitialize>(_initialize);
    on<GroupsEventGroupsChanged>(_groupsChanged);
    on<GroupsEventAddGroup>(_addGroup);
    on<GroupsEventUpdateGroup>(_updateGroup);
    on<GroupsEventRemoveGroup>(_removeGroup);
  }

  void _initialize(
    GroupsEventInitialize event,
    Emitter<GroupsState> emit,
  ) {
    _groupsSubscription = _groupsInterface.getGroupsSnapshots().listen(
      (groups) {
        final GroupedDbDocuments<Group> groupedDocuments =
            groupDbDocuments<Group>(groups);
        add(GroupsEventGroupsChanged(
          addedGroups: groupedDocuments.addedDocuments,
          updatedGroups: groupedDocuments.updatedDocuments,
          deletedGroups: groupedDocuments.removedDocuments,
        ));
      },
    );
  }

  void _groupsChanged(
    GroupsEventGroupsChanged event,
    Emitter<GroupsState> emit,
  ) {
    final List<Group> newGroups = [...state.allGroups];
    newGroups.addAll(event.addedGroups);
    for (final updatedGroup in event.updatedGroups) {
      final index = newGroups.indexWhere(
        (group) => group.id == updatedGroup.id,
      );
      newGroups[index] = updatedGroup;
    }
    for (final deletedGroup in event.deletedGroups) {
      newGroups.removeWhere((group) => group.id == deletedGroup.id);
    }
    emit(state.copyWith(
      allGroups: newGroups,
      initializationStatus: InitializationStatus.ready,
    ));
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
