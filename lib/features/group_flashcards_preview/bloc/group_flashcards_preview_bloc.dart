import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/flashcard.dart';
import '../../../domain/entities/group.dart';
import '../../../domain/use_cases/groups/get_group_use_case.dart';

part 'group_flashcards_preview_event.dart';

part 'group_flashcards_preview_state.dart';

class GroupFlashcardsPreviewBloc
    extends Bloc<GroupFlashcardsPreviewEvent, GroupFlashcardsPreviewState> {
  late final GetGroupUseCase _getGroupUseCase;
  StreamSubscription<Group>? _groupListener;

  GroupFlashcardsPreviewBloc({
    required GetGroupUseCase getGroupUseCase,
    String groupId = '',
    String groupName = '',
    List<Flashcard> flashcards = const [],
    String searchValue = '',
  }) : super(
          GroupFlashcardsPreviewState(
            groupId: groupId,
            groupName: groupName,
            flashcardsFromGroup: flashcards,
            searchValue: searchValue,
          ),
        ) {
    _getGroupUseCase = getGroupUseCase;
    on<GroupFlashcardsPreviewEventInitialize>(_initialize);
    on<GroupFlashcardsPreviewEventSearchValueChanged>(_searchValueChanged);
    on<GroupFlashcardsPreviewEventGroupChanged>(_groupChanged);
  }

  @override
  Future<void> close() {
    _groupListener?.cancel();
    return super.close();
  }

  Future<void> _initialize(
    GroupFlashcardsPreviewEventInitialize event,
    Emitter<GroupFlashcardsPreviewState> emit,
  ) async {
    _setGroupListener(event.groupId);
  }

  void _searchValueChanged(
    GroupFlashcardsPreviewEventSearchValueChanged event,
    Emitter<GroupFlashcardsPreviewState> emit,
  ) {
    emit(state.copyWith(
      searchValue: event.searchValue,
    ));
  }

  void _groupChanged(
    GroupFlashcardsPreviewEventGroupChanged event,
    Emitter<GroupFlashcardsPreviewState> emit,
  ) {
    emit(state.copyWith(
      groupId: event.group.id,
      groupName: event.group.name,
      flashcardsFromGroup: event.group.flashcards,
    ));
  }

  void _setGroupListener(String groupId) {
    _groupListener = _getGroupUseCase.execute(groupId: groupId).listen(
          (group) => add(
            GroupFlashcardsPreviewEventGroupChanged(group: group),
          ),
        );
  }
}
