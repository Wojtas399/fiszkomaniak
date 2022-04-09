import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_event.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashcardsEditorBloc
    extends Bloc<FlashcardsEditorEvent, FlashcardsEditorState> {
  late final GroupsBloc _groupsBloc;

  FlashcardsEditorBloc({
    required GroupsBloc groupsBloc,
  }) : super(const FlashcardsEditorState()) {
    _groupsBloc = groupsBloc;
    on<FlashcardsEditorEventInitialize>(_initialize);
  }

  void _initialize(
    FlashcardsEditorEventInitialize event,
    Emitter<FlashcardsEditorState> emit,
  ) {
    emit(state.copyWith(
      groupId: event.groupId,
      groupName: _groupsBloc.state.getNameById(event.groupId),
    ));
  }
}
