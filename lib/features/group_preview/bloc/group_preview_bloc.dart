import 'dart:async';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_event.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/dialogs/dialogs.dart';
import '../../../config/navigation.dart';
import '../../../core/groups/groups_event.dart';
import '../../../models/group_model.dart';
import '../../group_creator/bloc/group_creator_mode.dart';

class GroupPreviewBloc extends Bloc<GroupPreviewEvent, GroupPreviewState> {
  late final GroupsBloc _groupsBloc;
  late final Dialogs _dialogs;
  StreamSubscription? _groupsStateSubscription;

  GroupPreviewBloc({
    required GroupsBloc groupsBloc,
    required Dialogs dialogs,
  }) : super(const GroupPreviewState()) {
    _groupsBloc = groupsBloc;
    _dialogs = dialogs;
    on<GroupPreviewEventInitialize>(_initialize);
    on<GroupPreviewEventGroupUpdated>(_groupAdded);
    on<GroupPreviewEventEdit>(_edit);
    on<GroupPreviewEventAddFlashcards>(_addFlashcards);
    on<GroupPreviewEventRemove>(_remove);
  }

  void _initialize(
    GroupPreviewEventInitialize event,
    Emitter<GroupPreviewState> emit,
  ) {
    add(GroupPreviewEventGroupUpdated(groupId: event.groupId));
    _groupsStateSubscription = _groupsBloc.stream.listen((state) {
      add(GroupPreviewEventGroupUpdated(groupId: event.groupId));
    });
  }

  void _groupAdded(
    GroupPreviewEventGroupUpdated event,
    Emitter<GroupPreviewState> emit,
  ) {
    final Group? group = _groupsBloc.state.getGroupById(event.groupId);
    if (group != null) {
      emit(GroupPreviewState(group: group));
    }
  }

  void _edit(
    GroupPreviewEventEdit event,
    Emitter<GroupPreviewState> emit,
  ) {
    final Group? group = state.group;
    if (group != null) {
      Navigation.navigateToGroupCreator(GroupCreatorEditMode(group: group));
    }
  }

  void _addFlashcards(
    GroupPreviewEventAddFlashcards event,
    Emitter<GroupPreviewState> emit,
  ) {
    // TODO
  }

  Future<void> _remove(
    GroupPreviewEventRemove event,
    Emitter<GroupPreviewState> emit,
  ) async {
    final String? groupId = state.group?.id;
    if (groupId != null) {
      final bool? confirmation = await _dialogs.askForConfirmation(
        title: 'Czy na pewno chcesz usunąć grupę?',
        text:
            'Usunięcie grupy spowoduje również usunięcie wszystkich fiszek należących do niej.',
        confirmButtonText: 'Usuń',
      );
      if (confirmation == true) {
        _groupsBloc.add(GroupsEventRemoveGroup(groupId: groupId));
      }
    }
  }

  @override
  Future<void> close() {
    _groupsStateSubscription?.cancel();
    return super.close();
  }
}
