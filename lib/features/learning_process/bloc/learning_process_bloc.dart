import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_event.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LearningProcessBloc
    extends Bloc<LearningProcessEvent, LearningProcessState> {
  late final FlashcardsBloc _flashcardsBloc;

  LearningProcessBloc({
    required FlashcardsBloc flashcardsBloc,
  }) : super(const LearningProcessState()) {
    _flashcardsBloc = flashcardsBloc;
    on<LearningProcessEventInitialize>(_initialize);
    on<LearningProcessEventRememberedFlashcard>(_rememberedFlashcard);
    on<LearningProcessEventForgottenFlashcard>(_forgottenFlashcard);
    on<LearningProcessEventReset>(_reset);
  }

  void _initialize(
    LearningProcessEventInitialize event,
    Emitter<LearningProcessState> emit,
  ) {
    emit(state.copyWith(
      data: event.data,
      flashcards: _flashcardsBloc.state.getFlashcardsByGroupId(
        event.data.groupId,
      ),
    ));
  }

  void _rememberedFlashcard(
    LearningProcessEventRememberedFlashcard event,
    Emitter<LearningProcessState> emit,
  ) {
    final List<String> idsOfRememberedFlashcards = [
      ...state.idsOfRememberedFlashcards,
    ];
    if (!idsOfRememberedFlashcards.contains(event.flashcardId)) {
      idsOfRememberedFlashcards.add(event.flashcardId);
    }
    emit(state.copyWith(
      idsOfRememberedFlashcards: idsOfRememberedFlashcards,
      indexOfDisplayedFlashcard: _getNewIndexOfDisplayedFlashcard(),
    ));
  }

  void _forgottenFlashcard(
    LearningProcessEventForgottenFlashcard event,
    Emitter<LearningProcessState> emit,
  ) {
    final List<String> idsOfRememberedFlashcards = [
      ...state.idsOfRememberedFlashcards,
    ];
    idsOfRememberedFlashcards.removeWhere((id) => id == event.flashcardId);
    emit(state.copyWith(
      idsOfRememberedFlashcards: idsOfRememberedFlashcards,
      indexOfDisplayedFlashcard: _getNewIndexOfDisplayedFlashcard(),
    ));
  }

  void _reset(
    LearningProcessEventReset event,
    Emitter<LearningProcessState> emit,
  ) {
    emit(state.copyWith(indexOfDisplayedFlashcard: 0));
  }

  int _getNewIndexOfDisplayedFlashcard() {
    if (state.indexOfDisplayedFlashcard + 1 < state.amountOfAllFlashcards) {
      return state.indexOfDisplayedFlashcard + 1;
    }
    return state.indexOfDisplayedFlashcard;
  }
}
