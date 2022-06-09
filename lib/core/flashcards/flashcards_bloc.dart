import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/interfaces/flashcards_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/flashcard_model.dart';

part 'flashcards_event.dart';

part 'flashcards_state.dart';

part 'flashcards_status.dart';

class FlashcardsBloc extends Bloc<FlashcardsEvent, FlashcardsState> {
  late final FlashcardsInterface _flashcardsInterface;
  late final GroupsBloc _groupsBloc;
  StreamSubscription<GroupsState>? _groupsStateSubscription;

  FlashcardsBloc({
    required FlashcardsInterface flashcardsInterface,
    required GroupsBloc groupsBloc,
  }) : super(const FlashcardsState()) {
    _flashcardsInterface = flashcardsInterface;
    _groupsBloc = groupsBloc;
    on<FlashcardsEventInitialize>(_initialize);
    on<FlashcardsEventGroupsStateUpdated>(_groupsStateUpdated);
    on<FlashcardsEventSaveEditedFlashcards>(_saveEditedFlashcards);
    on<FlashcardsEventSaveRememberedFlashcards>(_saveRememberedFlashcards);
    on<FlashcardsEventUpdateFlashcard>(_updateFlashcard);
    on<FlashcardsEventRemoveFlashcard>(_removeFlashcard);
  }

  void _initialize(
    FlashcardsEventInitialize event,
    Emitter<FlashcardsState> emit,
  ) {
    add(FlashcardsEventGroupsStateUpdated(newGroupsState: _groupsBloc.state));
    _groupsStateSubscription = _groupsBloc.stream.listen((state) {
      add(FlashcardsEventGroupsStateUpdated(newGroupsState: state));
    });
  }

  void _groupsStateUpdated(
    FlashcardsEventGroupsStateUpdated event,
    Emitter<FlashcardsState> emit,
  ) {
    emit(state.copyWith(groupsState: event.newGroupsState));
  }

  Future<void> _saveEditedFlashcards(
    FlashcardsEventSaveEditedFlashcards event,
    Emitter<FlashcardsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: FlashcardsStatusLoading()));
      await _flashcardsInterface.saveEditedFlashcards(
        groupId: event.groupId,
        flashcards: event.flashcards,
      );
      if (event.justAddedFlashcards) {
        emit(state.copyWith(status: FlashcardsStatusFlashcardsAdded()));
      } else {
        emit(state.copyWith(status: FlashcardsStatusFlashcardsSaved()));
      }
    } catch (error) {
      emit(state.copyWith(
        status: FlashcardsStatusError(message: error.toString()),
      ));
    }
  }

  Future<void> _saveRememberedFlashcards(
    FlashcardsEventSaveRememberedFlashcards event,
    Emitter<FlashcardsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: FlashcardsStatusLoading()));
      await _flashcardsInterface.saveRememberedFlashcards(
        groupId: event.groupId,
        flashcardsIndexes: event.flashcardsIndexes,
      );
      emit(state.copyWith(status: FlashcardsStatusFlashcardsSaved()));
    } catch (error) {
      emit(state.copyWith(
        status: FlashcardsStatusError(message: error.toString()),
      ));
    }
  }

  Future<void> _updateFlashcard(
    FlashcardsEventUpdateFlashcard event,
    Emitter<FlashcardsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: FlashcardsStatusLoading()));
      await _flashcardsInterface.updateFlashcard(
        groupId: event.groupId,
        flashcard: event.flashcard,
      );
      emit(state.copyWith(status: FlashcardsStatusFlashcardUpdated()));
    } catch (error) {
      emit(state.copyWith(
        status: FlashcardsStatusError(message: error.toString()),
      ));
    }
  }

  Future<void> _removeFlashcard(
    FlashcardsEventRemoveFlashcard event,
    Emitter<FlashcardsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: FlashcardsStatusLoading()));
      await _flashcardsInterface.removeFlashcard(
        groupId: event.groupId,
        flashcard: event.flashcard,
      );
      emit(state.copyWith(status: FlashcardsStatusFlashcardRemoved()));
    } catch (error) {
      emit(state.copyWith(
        status: FlashcardsStatusError(message: error.toString()),
      ));
    }
  }

  @override
  Future<void> close() {
    _groupsStateSubscription?.cancel();
    return super.close();
  }
}
